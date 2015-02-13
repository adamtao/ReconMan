class Product < ActiveRecord::Base
	include Ownable
	has_many :tasks
	monetize :price_cents

	validates :name, presence: true, uniqueness: true
	validates :price_cents, presence: true

  def self.defect_clearance
    dc = where("name LIKE '%Defect Clearance%'").first_or_initialize
    if dc.new_record?
      dc.name = "Defect Clearance"
      dc.price_cents = 999
      dc.save!
    end
    dc
  end
end
