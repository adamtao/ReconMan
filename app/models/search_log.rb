class SearchLog < ActiveRecord::Base
  belongs_to :job_product
  belongs_to :user

  validates :user, presence: true
  validates :job_product, presence: true
  validates :status, presence: true

end
