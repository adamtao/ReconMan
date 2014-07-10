class County < ActiveRecord::Base
	belongs_to :state
	has_many :jobs

  validates :state, presence: true
	validates :name, presence: true, uniqueness: { scope: :state }
end
