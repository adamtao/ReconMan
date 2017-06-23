class Job < ApplicationRecord
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

  ransack_alias :attributes, :file_number_or_new_owner_or_old_owner_or_address_or_tasks_deed_of_trust_number

	belongs_to :client, touch: true
	belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
	has_many :tasks, dependent: :destroy, inverse_of: :job
	has_many :products, through: :tasks

	validates :client, presence: true
	validates :requestor, presence: true
	validates :file_number, presence: true
  validates :county, presence: true
  validates :state, presence: true

	# after_create :create_default_tasks # no longer doing this, instead creating tasks inline
  after_create :create_zipcode

	monetize :total_price_cents

	accepts_nested_attributes_for :tasks, reject_if: :all_blank

	def self.job_types
		[:tracking, :search, :special, :documentation]
	end

  def self.dashboard_jobs(options)
    default_options = {
      complete: false,
      user: User.new,
      fallback_to_all: true,
      hide_old: true,
      limit: 20
    }
    options = default_options.merge options
    user = options[:user]

    case options[:complete]
    when true
      if user.completed_job_ids.length > 0
        where(id: user.completed_job_ids).
          order("completed_at DESC").
          limit(options[:limit])
      elsif options[:fallback_to_all]
        where(workflow_state: "complete").
          order("completed_at DESC").
          limit(options[:limit])
      else
        nil
      end
    when false
      if user.current_job_ids.length > 0
        jobs = where(id: user.current_job_ids).includes(:tasks, clients).where(clients: { active: true })
        if options[:hide_old]
          jobs = jobs.where.not(["tasks.due_on < ?", 1.year.ago] )
        end
        jobs.order("tasks.due_on ASC").order("jobs.created_at ASC")
      elsif options[:fallback_to_all]
        jobs = where.not(workflow_state: "complete").includes(:tasks, :client).where(clients: { active: true })
        if options[:hide_old]
          jobs = jobs.where.not(["tasks.due_on < ?", 1.year.ago] )
        end
        jobs.order("tasks.due_on ASC").order("jobs.created_at ASC")
      else
        nil
      end
    end
  end

  def create_zipcode
    unless Zipcode.exists?(zipcode: zipcode)
      Zipcode.create(
        zipcode: zipcode,
        zip_type: "LEARNED",
        primary_city: city,
        state: state.abbreviation,
        county: county.name
      )
    end
  end

  def next
    cj = county.current_jobs(included_job: self)
    pos = cj.index(self)
    cj.length > pos ? cj[pos + 1] : false
  end

  def link_name
    file_number.present? ? file_number : deed_or_parcel_number
  end

  def branch
    begin
      self.requestor.branch
    rescue
      Branch.new
    end
  end

  def deed_or_parcel_number
    begin
      dashboard_task.deed_of_trust_number.present? ? dashboard_task.deed_of_trust_number : dashboard_task.parcel_number
    rescue
      "unknown #{self.id}"
    end
  end

  def total_price_cents
    tasks.inject(0){|total,task| total += task.price_cents.to_i}
  end

  # Base on the 'job_type', determine which default product type to build when
  # initializing a new job
	def default_tasks
		@default_tasks ||= Product.where(job_type: self.job_type.to_s)
	end

	def default_task_id
		if self.default_tasks.length > 0
			self.default_tasks.first.id
		else
			Product.all.length > 0 ? Product.first.id : nil
		end
	end

	def initialize_tasks
    self.default_tasks.each do |p|
      klass = "#{p.job_type.to_s.singularize.capitalize}Task".constantize
      self.tasks << klass.new(product_id: p.id,
                              lender: Lender.new)
    end
	end

	def dashboard_task
		@dashboard_task ||= self.tasks.where(product_id: default_task_id).first
	end

	def open_products
		@open_products ||= self.tasks.where.not(workflow_state: 'complete')
	end

  def tasks_for_report_between(start_on, end_on, job_status, exclude_billed)
    tasks = self.send("tasks_#{job_status.parameterize.gsub(/\-/, "_")}_between", start_on, end_on)
    tasks = tasks.where(billed: false) if exclude_billed
    tasks
  end

  def tasks_complete_between(start_on, end_on)
    self.tasks.where(workflow_state: 'complete').where(
      "cleared_on >= ? AND cleared_on <= ?",
      start_on,
      end_on
    )
  end

  def tasks_in_progress_between(start_on, end_on)
    self.tasks.where.not(workflow_state: ['new', 'complete', 'canceled'])
  end

  def tasks_new_between(start_on, end_on)
    self.tasks.where(workflow_state: 'new').where(
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
      Task.create(product: p,
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
