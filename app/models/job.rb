class Job < ActiveRecord::Base
	include Workflow
	workflow do
		state :new do
			event :search, :transitions_to => :open
		end
		state :open do
			event :mark_complete, :transitions_to => :complete
		end
		state :complete
		state :canceled
	end

	belongs_to :client
	belongs_to :county
	belongs_to :state
	belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
	has_many :products
	has_many :title_search_caches

	validates :client, presence: true
	validates :requestor, presence: true
	validates :county, presence: true
	validates :state, presence: true
	validates :name, presence: true, uniqueness: { scope: :client }

end
