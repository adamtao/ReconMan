class User < ActiveRecord::Base
  enum role: [:admin, :client, :manager, :processor]
  after_initialize :set_default_role, :if => :new_record?

  has_many :tasks, class_name: "JobProduct", foreign_key: :worker_id
  has_many :requested_jobs, class_name: "Job", foreign_key: :requestor_id
  belongs_to :branch # (if user works for a Client)

  validates :name, presence: true

  def set_default_role
    self.role ||= :processor
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, #:confirmable, #:registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  def self.processors
    processor_roles = [roles["processor"], roles["admin"]]
    where(role: processor_roles).where.not(name: nil).order("name")
  end

  def client
    if self.branch
      self.branch.client
    end
  end

  def current_job_ids
    @current_job_ids ||= self.tasks.where.not(workflow_state: "complete").order("due_on DESC").pluck(:job_id).uniq
  end

  def completed_job_ids
    @completed_job_ids ||= self.tasks.where(workflow_state: "complete").order("updated_at DESC").pluck(:job_id).uniq
  end
end
