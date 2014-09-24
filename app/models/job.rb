class Job < ActiveRecord::Base
	include RelatedCountyState
	include Ownable
	include Commentable
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
	belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
	has_many :job_products, dependent: :destroy, inverse_of: :job
	has_many :products, through: :job_products

	validates :client, presence: true
	validates :requestor, presence: true
	validates :file_number, presence: true

	# after_create :create_default_products # no longer doing this, instead creating tasks inline

	monetize :total_price_cents

	accepts_nested_attributes_for :job_products, reject_if: :all_blank

	def self.job_types 
		[:tracking, :search, :special] 
	end

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

	def link_name
		file_number.present? ? file_number : deed_or_parcel_number
	end

	def deed_or_parcel_number
		begin
			dashboard_product.deed_of_trust_number.present? ? dashboard_product.deed_of_trust_number : dashboard_product.parcel_number
		rescue
			"unknown #{self.id}"
		end
	end

	def total_price_cents
		job_products.inject(0){|total,jp| total += jp.price_cents}
	end

	# Base on the 'job_type', determine which default product type to build when
	# initializing a new job
	def default_products
		@default_products ||= Product.where(job_type: self.job_type.to_s)
	end

	def default_product_id
		if self.default_products.length > 0
			self.default_products.first.id
		else
			Product.all.length > 0 ? Product.first.id : nil
		end		
	end

	def initialize_job_products
    self.default_products.each do |p|
      self.job_products << JobProduct.new(product_id: p.id)
    end		
	end

	def dashboard_product
		@dashboard_product ||= self.job_products.where(product_id: default_product_id).first
	end

	def open_products
		@open_products ||= self.job_products.where.not(workflow_state: 'complete')
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
