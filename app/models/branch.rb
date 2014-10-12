class Branch < ActiveRecord::Base
	include Ownable

	belongs_to :client
	belongs_to :state
	has_many :users, dependent: :destroy

  validates :client, presence: true
	validates :name, presence: true, uniqueness: { scope: :client }

	def jobs
		self.client.jobs.where(requestor_id: self.users.pluck(:id))
	end

  def current_jobs
    jobs.where.not(workflow_state: 'complete') #.joins(:job_products).order("job_products.due_on DESC")
  end
end
