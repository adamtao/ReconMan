class JobProduct < ActiveRecord::Base
	include Workflow
	workflow do
		state :new do
			event :search, :transitions_to => :open
		end
		state :open do
			event :change_in_cached_response, :transitions_to => :needs_review
			event :mark_complete, :transitions_to => :complete
		end
		state :needs_review do 
			event :mark_complete, :transitions_to => :complete
		end
		state :complete
		state :canceled
	end

	belongs_to :job 
	belongs_to :product

	has_many :title_search_caches, class_name: "TitleSearchCache"

	monetize :price_cents

	validates :price_cents, presence: true
	validates :job, presence: true
	validates :product, presence: true

	before_create :determine_due_date

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
	def search
		return false if self.search_url.blank?

		uri = URI.parse(self.search_url)
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		if ENV['TRACKING_USER_AGENT']
			request["User-Agent"] = ENV['TRACKING_USER_AGENT']
		end
		response = http.request(request)

		log_search_results(response) if response.success?
	end

	def log_search_results(response)
		TitleSearchCache.create({
			content: response.content,
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
			self.job.mark_complete!
		end
	end
end
