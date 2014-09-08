class Job < ActiveRecord::Base
	include Ownable
	include Workflow
	workflow do
		state :new do
			event :mark_complete, transitions_to: :complete
		end
		state :complete do
			event :re_open, transitions_to: :new
		end
		state :canceled
	end

	belongs_to :client, touch: true
	belongs_to :county
	belongs_to :state
	belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
	has_many :job_products, dependent: :destroy
	has_many :products, through: :job_products
	has_many :title_search_caches

	validates :client, presence: true
	validates :requestor, presence: true
	validates :county, presence: true
	validates :state, presence: true
	validates :file_number, presence: true

	after_create :create_default_products

	monetize :total_price_cents
	monetize :payoff_amount_cents

	def self.dashboard_jobs(options)
		default_options = {limit: 100, complete: false, user: User.new, fallback_to_all: true}
		options = default_options.merge options
		user = options[:user]

		case options[:complete]
		when true
			if user.completed_job_ids.length > 0
				where(id: user.completed_job_ids).limit(options[:limit])
			elsif options[:fallback_to_all]
				where(workflow_state: "complete").order("completed_at DESC").limit(options[:limit])
			else
				nil
			end
		when false
  		if user.current_job_ids.length > 0
  			where(id: user.current_job_ids)
  		elsif options[:fallback_to_all]
  			where.not(workflow_state: "complete").joins(:job_products).order("job_products.due_on ASC").limit(options[:limit])
  		else
  			nil
  		end
		end
	end

	def create_default_products
		Product.defaults.each do |product|
			self.job_products << JobProduct.new(
				creator: self.creator,
				worker: self.creator,
				product: product, 
				price: self.client.product_price(product)
			)
		end
	end

	def total_price_cents
		job_products.inject(0){|total,jp| total += jp.price_cents}
	end

	def dashboard_product
		self.job_products.where(product_id: Product.defaults.first.id).first
	end

	def mark_complete
		self.completed_at = Time.zone.now
		self.save
	end

	def re_open
		self.completed_at = nil
		self.save
	end

end
