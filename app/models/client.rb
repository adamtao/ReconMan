class Client < ApplicationRecord
  include LiquidMethods
	include Ownable
	has_many :jobs, -> { includes(:tasks) }, dependent: :destroy
	has_many :branches, dependent: :destroy
	has_many :users, through: :branches
	has_many :client_products, dependent: :destroy
	belongs_to :billing_state, :class_name => "State", :foreign_key => "billing_state_id"

	validates :name, presence: true, uniqueness: true

  liquid_methods :name,
    :website,
    :billing_address,
    :billing_city,
    :billing_state,
    :billing_zipcode

	def product_price(product)
		self.client_products.find_or_initialize_by(product_id: product.id).price
	end

	def billing_contact
		users.where(billing_contact: true).first
	end

	def primary_contact
		users.where(primary_contact: true).first
	end

  def current_jobs
    @current_jobs ||= jobs.where.not(workflow_state: 'complete').order("tasks.due_on ASC").order("tasks.created_at ASC").order("jobs.created_at ASC")
  end

end
