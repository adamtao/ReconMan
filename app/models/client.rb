class Client < ActiveRecord::Base
	has_many :jobs
	has_many :branches
	has_many :users, through: :branches

	validates :name, presence: true, uniqueness: true

end
