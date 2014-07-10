class Branch < ActiveRecord::Base
	belongs_to :client
	has_many :users

  validates :client, presence: true
	validates :name, presence: true, uniqueness: { scope: :client }
end
