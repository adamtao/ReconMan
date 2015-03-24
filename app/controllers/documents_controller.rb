class DocumentsController < ActionController::Base
  before_action :get_task_type
  before_action :load_job_and_task
  before_action :set_document, only: [:destroy]

  def create
    document = Document.new(document_params)
    document.task = @task
    document.save!
    redirect_to @job
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to job_path(@job), notice: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_document
      @document = Document.find(params[:id])
    end

    def get_task_type
      @task_type = "task"
      if request.path.match(/\/(\w*\_task)/)
        @task_type = $1
      end
      @klass = @task_type.gsub(/\_/, ' ').titleize.gsub(/\s/, '').constantize
    end

    def load_job_and_task
      @job = Job.find(params[:job_id])
      @task = @klass.find(params["#{@task_type}_id".to_sym])
    end

    def document_params
      params.require(:document).permit(:file)
    end
end
