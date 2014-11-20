class Lender < ActiveRecord::Base
  has_many :job_products

  validates :name, presence: true, uniqueness: true
end
