class DashboardController < ApplicationController
  def index
  	@jobs = Job.all.limit(100)
  	@clients = Client.all.limit(10)
  	@products = Product.all
  end
end
