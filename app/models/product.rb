class Product < ActiveRecord::Base
	has_many :job_products
	monetize :price_cents

	validates :name, presence: true, uniqueness: true
	validates :price_cents, presence: true

	def self.defaults
		where(default: true)
	end
end
