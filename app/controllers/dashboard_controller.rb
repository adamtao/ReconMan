class DashboardController < ApplicationController

  def index
    @current_jobs = Job.dashboard_jobs(user: current_user, complete: false, per_page: 20, page: params[:page])
  	@completed_jobs = Job.dashboard_jobs(user: current_user, complete: true, limit: 25)
  	@clients = Client.order("updated_at DESC").limit(10)
  	@products = Product.all
    @counties_needing_work = County.needing_work.limit(20)
  end

end
