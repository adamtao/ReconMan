class DashboardController < ApplicationController

  def index
  	@current_jobs = Job.dashboard_jobs(user: current_user, complete: false, limit: 20)
  	@completed_jobs = Job.dashboard_jobs(user: current_user, complete: true, limit: 25)
  	@clients = Client.order("updated_at DESC").limit(10)
  	@products = Product.all
  end

end
