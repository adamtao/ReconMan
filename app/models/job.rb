class Job < ActiveRecord::Base
	include Workflow
	workflow do
		state :new do
			event :mark_complete, transitions_to: :complete
		end
		state :complete do
			event :re_open, transitions_to: :new
		end
		state :canceled
	end

	belongs_to :client
	belongs_to :county
	belongs_to :state
	belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
	has_many :job_products, dependent: :destroy
	has_many :products, through: :job_products
	has_many :title_search_caches

	validates :client, presence: true
	validates :requestor, presence: true
	validates :county, presence: true
	validates :state, presence: true
	validates :parcel_number, presence: true

	after_create :create_default_products

	monetize :total_price_cents

	def create_default_products
		Product.defaults.each do |product|
			self.job_products << JobProduct.new(product: product, price: self.client.product_price(product))
		end
	end

	def total_price_cents
		job_products.inject(0){|total,jp| total += jp.price_cents}
	end

	def dashboard_product
		self.job_products.where(product_id: Product.defaults.first.id).first
	end

	def mark_complete
		self.completed_at = Time.zone.now
		self.save
	end

	def re_open
		self.completed_at = nil
		self.save
	end

end
