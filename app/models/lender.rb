class Lender < ActiveRecord::Base
  has_many :tracking_jobs

  validates :name, presence: true, uniqueness: true
end
