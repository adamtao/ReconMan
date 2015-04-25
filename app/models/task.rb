class Task < ActiveRecord::Base
	include Ownable
	include Workflow

  # Generic task workflow. Override in subclasses (app/models/tasks/*.rb)
  workflow do
    state :in_progress do
      event :change_in_cached_response, transitions_to: :needs_review
      event :mark_complete, transitions_to: :complete
      event :first_notice_time_passed, transitions_to: :needs_first_notice
      event :send_first_notice, transitions_to: :first_notice
    end
    state :to_be_searched_manually do
      event :send_first_notice, transitions_to: :first_notice
      event :mark_complete, transitions_to: :complete
      event :first_notice_time_passed, transitions_to: :needs_first_notice
    end
    state :to_be_processed_manually do
      event :mark_complete, transitions_to: :complete
      event :first_notice_time_passed, transitions_to: :needs_first_notice
      event :send_first_notice, transitions_to: :first_notice
    end
    state :needs_first_notice do
      event :mark_complete, transitions_to: :complete
      event :send_first_notice, transitions_to: :first_notice
    end
    state :first_notice do
      event :mark_complete, transitions_to: :complete
      event :send_second_notice, transitions_to: :second_notice
      event :second_notice_time_passed, transitions_to: :needs_second_notice
    end
    state :needs_second_notice do
      event :mark_complete, transitions_to: :complete
      event :send_second_notice, transitions_to: :second_notice
    end
    state :second_notice do
      event :mark_complete, transitions_to: :complete
    end
    state :needs_review do
      event :mark_complete, transitions_to: :complete
    end
    state :complete do
      event :re_open, transitions_to: :in_progress
    end
    state :canceled
  end

	belongs_to :job
	belongs_to :product
  belongs_to :lender
	belongs_to :worker, class_name: "User", foreign_key: :worker_id

  has_many :documents
  has_many :search_logs
	has_many :title_search_caches, class_name: "TitleSearchCache"

	monetize :price_cents, allow_nil: true
	monetize :payoff_amount_cents, allow_nil: true

	validates :price_cents, presence: true
	validates :job, presence: true
	validates :product, presence: true
	validates :worker, presence: true
  validates :payoff_amount_cents, presence: true

  accepts_nested_attributes_for :lender, reject_if: proc { |attributes| attributes['name'].blank? }

	after_save :advance_state
	before_create :determine_due_date, :set_price
  before_save :generate_search_url
  #after_initialize :auto_advance_to_next_notice_stage

  def self.for_report_between(start_on, end_on, job_status, exclude_billed)
    tasks = self.send("#{job_status.parameterize.gsub(/\-/, "_")}_between", start_on, end_on)
    tasks = tasks.where(billed: false) if exclude_billed
    tasks
  end

  def self.complete_between(start_on, end_on)
    where(workflow_state: 'complete').where(
      "tasks.cleared_on >= ? AND tasks.cleared_on <= ?",
      start_on,
      end_on
    )
  end

  def self.in_progress_between(start_on, end_on)
    where.not(workflow_state: ['new', 'complete', 'canceled'])
  end

  def self.new_between(start_on, end_on)
    where(workflow_state: 'new').where(
      "tasks.created_at >= ? AND tasks.created_at <=?",
      start_on,
      end_on
    )
  end

	def advance_state
		if (new_deed_of_trust_number_changed? && new_deed_of_trust_number.present?) && self.can_mark_complete?
			self.recorded_on ||= Date.today
			self.mark_complete!
		end
	end

  def auto_advance_to_next_notice_stage
    if !self.new_record? && self.job && self.job.close_on.present?
      if (self.can_first_notice_time_passed? && self.first_notice_date <= Date.today)
        self.first_notice_time_passed!
      elsif (self.can_second_notice_time_passed? && self.second_notice_date <= Date.today)
        self.second_notice_time_passed!
      end
    end
  end

	def determine_due_date
		ref = self.job.close_on.present? ? self.job.close_on : Date.today
		self.due_on = ref.advance(days: self.job.state.due_within_days)
	end

	def set_price
		self.price = self.job.client.product_price(self.product)
	end

  # TODO: support POST search urls
  def generate_search_url
    begin
      if self.search_url.blank? && job.county.search_template_url.present?
        params = generate_search_params.to_s
        if job.county.search_method == "GET"
          self.search_url = job.county.search_template_url.gsub(/\{\{params\}\}/, "?#{params}")
        end
      end
    rescue
      # don't worry if something went wrong generating the url
    end
  end

	def name
		self.product.name
	end

	def county
    self.job.county || County.new
	end

	def late?
		self.due_on.to_date < Date.today
	end

	def quick_search_url
		self.search_url.present? ? self.search_url : self.county.search_url
	end

	# TODO: Make sure the auto-tracking can handle POST and GET
	# TODO: Run search in background process
	def search
		return false if self.search_url.blank?
		begin
			uri = URI.parse(self.search_url)
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Get.new(uri.request_uri)
			if ENV['TRACKING_USER_AGENT']
				request["User-Agent"] = ENV['TRACKING_USER_AGENT']
			end
			response = http.request(request)

			log_search_results(response) if response.kind_of? Net::HTTPSuccess
		rescue # something bad happened, ignore for now
			false
		end
	end

	def log_search_results(response)
		TitleSearchCache.create({
			content: response.body,
			task_id: self.id
		})
	end

	def search_changed?
		title_search_caches.last && title_search_caches.last.change_detected?
	end

  def expected_completion_on
    begin
      if self.lender.average_days_to_complete.to_i > 0
        @expected_completion_on ||= self.job.close_on.advance(days: lender.average_days_to_complete)
      end
    rescue
      nil
    end
  end

  def send_first_notice
    self.update_column(:first_notice_sent_on, Date.today)
  end

  def send_second_notice
    self.update_column(:second_notice_sent_on, Date.today)
  end

	# When this product is complete, mark the parent job complete unless
	# it has other incomplete products
	def mark_complete
    self.recorded_on ||= Date.today
    self.update_column(:cleared_on, Date.today)
    if self.lender
      self.lender.calculate_days_to_complete!
    end
		unless self.job.open_products.where.not(id: self.id).count > 0
			self.job.mark_complete! if self.job.can_mark_complete?
		end
	end

  def re_open
    if self.job.can_re_open?
      self.cleared_on = nil
      self.job.re_open!
    end
  end

	# Quick way to complete/un-complete, by convention, invokes the last action for the current state
	def toggle!
		if self.can_mark_complete?
			self.mark_complete!
		elsif self.can_re_open?
			self.re_open!
		end
	end

  # Several 'lookup and format' methods for exporting reports to Excel.
  def file_number
    begin
      self.job.file_number
    rescue
      ""
    end
  end

  def client_name
    begin
      self.job.client.name
    rescue
      ""
    end
  end

  def branch_name
    begin
      self.job.branch.name
    rescue
      ""
    end
  end

  def requestor_name
    begin
      self.job.requestor.name
    rescue
      ""
    end
  end

  def close_date
    begin
      self.job.close_on
    rescue
      ""
    end
  end

  def lender_name
    begin
      self.lender.name
    rescue
      ""
    end
  end

  def report_price
    begin
      self.price.to_f
    rescue
      ""
    end
  end

  def county_name
    begin
      self.job.county.name
    rescue
      ""
    end
  end

  def state_abbreviation
    begin
      self.job.state.abbreviation
    rescue
      ""
    end
  end

  def first_notice_date
    @first_notice_date ||= self.first_notice_sent_on.present? ?
      self.first_notice_sent_on :
      self.base_date.advance(days: (self.job.state.time_to_dispute_days.to_i + 5)).to_date
  end

  def second_notice_date
    @second_notice_date ||= self.second_notice_sent_on.present? ?
      self.second_notice_sent_on :
      self.first_notice_date.advance(days: (self.job.state.time_to_record_days + 10)).to_date
  end

  protected

  def generate_search_params
    p = job.county.search_params
    if p.present? && validate_fields_for_url_generation
      p.gsub(/\{\{(\w*)\}\}/) { self.send($1.to_sym) }
    end
  end

  def validate_fields_for_url_generation
    job.county.search_params.to_s.scan(/\{\{(\w*)\}\}/).flatten.each do |p|
      raise "required fields are empty" if self.send(p.to_sym).blank?
    end
  end

  # Safe date used for calculating other related dates
  def base_date
    self.job.close_on || self.job.created_at.to_date
  end
end
