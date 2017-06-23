class DashboardController < ApplicationController

  def index
    @hide_old = true
    if params[:hide_old]
      @hide_old = !!(params[:hide_old].to_i == 1)
    end
    @current_jobs = Job.dashboard_jobs(
      user: current_user,
      complete: false,
      hide_old: @hide_old,
      per_page: 20,
      page: params[:page]
    )
    @clients = Client.where(active: true).order("updated_at DESC").limit(10)
  	@products = Product.all
    @counties_needing_work = County.needing_work
  end

end
