class DashboardController < ApplicationController

  def index
  	@current_jobs = Job.where.not(workflow_state: "complete").joins(:job_products).order("job_products.due_on DESC").limit(100)
  	@completed_jobs = Job.where(workflow_state: "complete").order("completed_at DESC").limit(25)
  	@clients = Client.order("updated_at DESC").limit(10)
  	@products = Product.all
  end

end
