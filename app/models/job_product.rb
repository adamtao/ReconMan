class JobProduct < ActiveRecord::Base
	include Ownable
	include Workflow

	workflow do
#		state :new do
#			event :search, transitions_to: :in_progress
#			event :offline_search, transitions_to: :to_be_searched_manually
#			event :process_manually, transitions_to: :to_be_processed_manually
#     event :send_first_notice, transitions_to: :first_notice
#		end
		state :in_progress do
			event :change_in_cached_response, transitions_to: :needs_review
			event :mark_complete, transitions_to: :complete
      event :send_first_notice, transitions_to: :first_notice
	 	end
		state :to_be_searched_manually do
      event :send_first_notice, transitions_to: :first_notice
			event :mark_complete, transitions_to: :complete
	  end
		state :to_be_processed_manually do
			event :mark_complete, transitions_to: :complete
      event :send_first_notice, transitions_to: :first_notice
		end
    state :first_notice do
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
  #validates :lender, presence: true # but only for tracking/special jobs, I think
	validates :job, presence: true
	validates :product, presence: true
	validates :worker, presence: true
  validates :payoff_amount_cents, presence: true

  accepts_nested_attributes_for :lender, reject_if: proc { |attributes| attributes['name'].blank? }

	after_save :advance_state
	before_create :determine_due_date, :set_price
  before_save :generate_search_url

	def advance_state
#		if search_url_changed? && self.can_search?
#			self.search!
#		elsif !self.product.performs_search? && self.can_process_manually?
#		self.process_manually!

#			self.offline_search!
		if (new_deed_of_trust_number_changed? && new_deed_of_trust_number.present?) && self.can_mark_complete?
			self.recorded_on ||= Date.today
			self.mark_complete!
		end
	end

	def determine_due_date
		ref = self.job.close_on.present? ? self.job.close_on : Date.today
		self.due_on = ref.advance(days: self.job.state.due_within_days)
	end

	def set_price
		self.price = self.job.client.product_price(self.product)
	end

  def generate_search_url
    begin
      if self.search_url.blank? && self.job.county.search_template_url.present?
        params = ""
        if self.job.county.search_params.present?
          params = self.job.county.search_params
          params.gsub!(/\{\{(\w*)\}\}/){ self.send($1.to_sym) }
          if self.job.county.search_method == "GET"
            params = "?#{params}"
          end
        end
        self.search_url = self.job.county.search_template_url
        self.search_url.gsub!(/\{\{params\}\}/, params)
      end
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
			job_product_id: self.id
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
    @first_notice_date ||= self.base_date.advance(days: (self.job.state.time_to_dispute_days.to_i + 5)).to_date
  end

  def second_notice_date
    @second_notice_date ||= self.base_date.advance(days: (self.job.state.time_to_dispute_days.to_i + self.job.state.time_to_record_days + 15)).to_date
  end

  protected

  # Safe date used for calculating other related dates
  def base_date
    self.job.close_on || self.job.created_at.to_date
  end
end
