class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin, :client, :manager]
  after_initialize :set_default_role, :if => :new_record?

  has_many :requested_jobs, :class_name => "Job", :foreign_key => "requestor_id"

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
