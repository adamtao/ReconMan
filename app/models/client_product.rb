class ClientProduct < ActiveRecord::Base
	include Ownable
	belongs_to :client 
	belongs_to :product 
	monetize :price_cents

	validates :client_id, presence: true
	validates :product_id, presence: true, uniqueness: { scope: :client_id }

	after_initialize :load_price

	def load_price
		self.price_cents = self.product.price_cents if self.new_record? && self.product.present? && self.price_cents <= 0
	end
end
