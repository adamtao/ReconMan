class State < ActiveRecord::Base
	has_many :counties, -> { order('name') }

	validates :name, presence: true, uniqueness: true
	validates :abbreviation, presence: true, uniqueness: true

	after_initialize :load_defaults if :new_record?

	scope :active, -> { where(active: true).order('UPPER(name)') }
	scope :inactive, -> { where(active: false).order('UPPER(name)') }

	def self.due_within_options
		[30, 60, 90]
	end

	def load_defaults
		self.time_to_notify_days  ||= self.class.due_within_options.first
		self.time_to_dispute_days ||= self.class.due_within_options.first
		self.time_to_record_days  ||= self.class.due_within_options.first
	end

	def due_within_days
		self.time_to_notify_days.to_i + self.time_to_dispute_days.to_i + self.time_to_record_days.to_i
	end

end
