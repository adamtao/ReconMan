class Lender < ActiveRecord::Base
  has_many :job_products

  validates :name, presence: true, uniqueness: true

  def merge_with!(other_lender)
    other_lender.job_products.update_all(lender_id: self.id)
    other_lender.destroy
  end
end
