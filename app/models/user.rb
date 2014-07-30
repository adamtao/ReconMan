class User < ActiveRecord::Base
  enum role: [:admin, :client, :manager, :processor]
  after_initialize :set_default_role, :if => :new_record?

  has_many :requested_jobs, :class_name => "Job", :foreign_key => "requestor_id"
  belongs_to :branch # (if user works for a Client)

  validates :name, presence: true

  def set_default_role
    self.role ||= :processor
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def client
    if self.branch
      self.branch.client
    end
  end
end
