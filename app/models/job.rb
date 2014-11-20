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
  validates :county, presence: true
  validates :state, presence: true

	# after_create :create_default_products # no longer doing this, instead creating tasks inline

	monetize :total_price_cents

	accepts_nested_attributes_for :job_products, reject_if: :all_blank

	def self.job_types
		[:tracking, :search, :special]
	end

	def self.dashboard_jobs(options)
    default_options = {
      complete: false,
      user: User.new,
      fallback_to_all: true,
      page: 1,
      per_page: 20,
      limit: 20
    }
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
        where(id: user.current_job_ids).paginate(page: options[:page], per_page: options[:per_page])
  		elsif options[:fallback_to_all]
        where.not(workflow_state: "complete").joins(:job_products).order("job_products.due_on ASC").paginate(page: options[:page], per_page: options[:per_page])
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
    job_products.inject(0){|total,jp| total += jp.price_cents.to_i}
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
      jp = JobProduct.new(product_id: p.id)
      jp.lender = Lender.new
      self.job_products << jp
    end
	end

	def dashboard_product
		@dashboard_product ||= self.job_products.where(product_id: default_product_id).first
	end

	def open_products
		@open_products ||= self.job_products.where.not(workflow_state: 'complete')
	end

  def job_products_for_report_between(start_on, end_on, job_status, exclude_billed)
    jp = self.send("job_products_#{job_status.parameterize.gsub(/\-/, "_")}_between", start_on, end_on)
    jp = jp.where(billed: false) if exclude_billed
    jp
  end

  def job_products_complete_between(start_on, end_on)
    self.job_products.where(workflow_state: 'complete').where(
      "cleared_on >= ? AND cleared_on <= ?",
      start_on,
      end_on
    )
  end

  def job_products_in_progress_between(start_on, end_on)
    self.job_products.where.not(workflow_state: ['new', 'complete', 'canceled'])
  end

  def job_products_new_between(start_on, end_on)
    self.job_products.where(workflow_state: 'new').where(
      "created_at >= ? AND created_at <=?",
      start_on,
      end_on
    )
  end

	def mark_complete
		self.completed_at = Time.zone.now
		self.save
	end

  def add_defect_clearance(worker)
    if p = Product.defect_clearance
      JobProduct.create(product: p,
      	job: self,
      	price: self.client.product_price(p),
      	worker: worker)
    end
  end

	def re_open
		self.completed_at = nil
		self.save
	end

end
