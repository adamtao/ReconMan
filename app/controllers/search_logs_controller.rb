class SearchLogsController < ActionController::Base
  before_action :load_job_and_task

  def create
    search_log = SearchLog.new(search_log_params)
    search_log.task = @task
    search_log.user = current_user
    search_log.save!
    redirect_to @job
  end

  private

  def load_job_and_task
    @job = Job.find(params[:job_id])
    @task = Task.find(params[:task_id])
  end

  def search_log_params
    params.require(:search_log).permit(:status)
  end
end
