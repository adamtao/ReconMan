class Client < ActiveRecord::Base
	include Ownable
	has_many :jobs, -> { includes(:tasks) }, dependent: :destroy
	has_many :branches, dependent: :destroy
	has_many :users, through: :branches
	has_many :client_products, dependent: :destroy
	belongs_to :billing_state, :class_name => "State", :foreign_key => "billing_state_id"

	validates :name, presence: true, uniqueness: true

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
    jobs.where.not(workflow_state: 'complete')#.joins(:tasks).order("tasks.due_on DESC")
  end

end
