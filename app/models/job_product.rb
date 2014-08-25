class JobProduct < ActiveRecord::Base
	include Ownable
	include Workflow
	workflow do
		state :new do
			event :search, transitions_to: :in_progress
		end
		state :in_progress do
			event :change_in_cached_response, transitions_to: :needs_review
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

	has_many :title_search_caches, class_name: "TitleSearchCache"

	monetize :price_cents

	validates :price_cents, presence: true
	validates :job, presence: true
	validates :product, presence: true

	after_save :advance_state
	before_create :determine_due_date

	def advance_state
		if search_url_changed? && self.can_search?
			self.search!
		end
	end

	def determine_due_date
		self.due_on = Date.today.advance(days: self.job.state.due_within_days)
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

	# When this product is complete, mark the parent job complete unless
	# it has other incomplete products
	def mark_complete
		unless self.job.job_products.where.not(id: self.id, workflow_state: 'complete').count > 0
			self.job.mark_complete! if self.job.can_mark_complete?
		end
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
