class Branch < ActiveRecord::Base
	belongs_to :client
	belongs_to :state
	has_many :users, dependent: :destroy

  validates :client, presence: true
	validates :name, presence: true, uniqueness: { scope: :client }

	def jobs
		self.client.jobs.where(requestor_id: self.users.pluck(:id))
	end
end
