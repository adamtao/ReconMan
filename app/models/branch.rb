class Branch < ApplicationRecord
	include Ownable

	belongs_to :client
	belongs_to :state
	has_many :users, -> { order(:name) }, dependent: :destroy

  validates :client, presence: true
	validates :name, presence: true, uniqueness: { scope: :client }

	def jobs
		client.jobs.where(requestor_id: self.users.pluck(:id))
	end

  def current_jobs
    @current_jobs ||= client.current_jobs.where(requestor_id: self.users.pluck(:id))
  end
end
