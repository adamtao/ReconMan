class SearchLogsController < ActionController::Base
  before_action :load_job_and_job_product

  def create
    search_log = SearchLog.new(search_log_params)
    search_log.job_product = @job_product
    search_log.user = current_user
    search_log.save
    redirect_to @job
  end

  private

  def load_job_and_job_product
    @job = Job.find(params[:job_id])
    @job_product = JobProduct.find(params[:job_product_id])
  end

  def search_log_params
    params.require(:search_log).permit(:status)
  end
end
