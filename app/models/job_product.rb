class JobProduct < ActiveRecord::Base
	include Ownable
	include Workflow

	workflow do
		state :new do
			event :search, transitions_to: :in_progress
			event :offline_search, transitions_to: :to_be_searched_manually
			event :process_manually, transitions_to: :to_be_processed_manually
		end
    state :defect do
      event :clear, transitions_to: :new
    end
		state :to_be_searched_manually do
			event :mark_complete, transitions_to: :complete
	    event :mark_defect, transitions_to: :defect
	  end
		state :to_be_processed_manually do 
			event :mark_complete, transitions_to: :complete
		end
		state :in_progress do
			event :change_in_cached_response, transitions_to: :needs_review
			event :mark_complete, transitions_to: :complete
      event :mark_defect, transitions_to: :defect
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
	belongs_to :worker, class_name: "User", foreign_key: :worker_id

	has_many :title_search_caches, class_name: "TitleSearchCache"

	monetize :price_cents, allow_nil: true
	monetize :payoff_amount_cents, allow_nil: true

	validates :price_cents, presence: true
	validates :job, presence: true
	validates :product, presence: true
	validates :worker, presence: true

	after_save :advance_state
	before_create :determine_due_date, :set_price

	def advance_state
		if search_url_changed? && self.can_search?
			self.search!
		elsif !self.product.performs_search? && self.can_process_manually?
			self.process_manually!
		elsif self.job.county.offline_search? && self.can_offline_search?
			self.offline_search!
		elsif (new_deed_of_trust_number_changed? && new_deed_of_trust_number.present?) && self.can_mark_complete?
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

	def name
		self.product.name
	end

	def county
		self.job.county
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
      self.job.close_on.advance(days: job.county.average_days_to_complete)
    rescue
      nil
    end
  end

	# When this product is complete, mark the parent job complete unless
	# it has other incomplete products
	def mark_complete
    self.recorded_on ||= Date.today
    self.job.county.calculate_days_to_complete!
		unless self.job.open_products.where.not(id: self.id).count > 0
			self.job.mark_complete! if self.job.can_mark_complete?
		end
	end

  def mark_defect
    self.job.add_defect_clearance(self.worker)
  end
  
	def re_open
		self.job.re_open! if self.job.can_re_open?
	end

	# Quick way to complete/un-complete, by convention, invokes the last action for the current state
	def toggle!
		if self.can_mark_complete? 
			self.mark_complete! 
		elsif self.can_re_open?
			self.re_open!
		end
	end
end
