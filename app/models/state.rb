class State < ActiveRecord::Base
	has_many :counties, -> { order('name') }

	validates :name, presence: true, uniqueness: true
	validates :abbreviation, presence: true, uniqueness: true
end
