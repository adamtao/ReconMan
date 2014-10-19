class SearchLog < ActiveRecord::Base
  belongs_to :job_product
  belongs_to :user

  validates :user, presence: true
  validates :job_product, presence: true
  validates :status, presence: true

  after_create :advance_job_product

  def advance_job_product
    if self.job_product.can_search?
      self.job_product.search!
    end
  end
end
