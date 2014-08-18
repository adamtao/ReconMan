class Client < ActiveRecord::Base
	has_many :jobs, dependent: :destroy
	has_many :branches, dependent: :destroy
	has_many :users, through: :branches
	has_many :client_products, dependent: :destroy
	belongs_to :billing_state, :class_name => "State", :foreign_key => "billing_state_id"

	validates :name, presence: true, uniqueness: true

	def product_price(product)
		self.client_products.find_or_initialize_by(product_id: product.id).price
	end

	# TODO: get the billing contact
	def billing_contact
	end

	# TODO: get the primary contact
	def primary_contact
	end
end
