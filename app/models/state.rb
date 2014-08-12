class State < ActiveRecord::Base
	has_many :counties, -> { order('name') }

	validates :name, presence: true, uniqueness: true
	validates :abbreviation, presence: true, uniqueness: true

	after_initialize :load_defaults

	def self.due_within_options
		[30, 60, 90]
	end

	def load_defaults
		self.due_within_days ||= self.class.due_within_options.first
	end
end