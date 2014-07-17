class Client < ActiveRecord::Base
	has_many :jobs
	has_many :branches
	has_many :users, through: :branches
	has_many :client_products

	validates :name, presence: true, uniqueness: true

	def product_price(product)
		self.client_products.find_or_initialize_by(product_id: product.id).price
	end
end
