class DashboardController < ApplicationController

  def index
    @current_jobs = Job.dashboard_jobs(user: current_user, complete: false, per_page: 20, page: params[:page])
  	@clients = Client.order("updated_at DESC").limit(10)
  	@products = Product.all
    @counties_needing_work = County.needing_work
  end

end
