class DocumentsController < ActionController::Base
  before_action :load_job_and_job_product

  def create
    document = Document.new(document_params)
    document.job_product = @job_product
    document.save!
    redirect_to @job
  end

  private

  def load_job_and_job_product
    @job = Job.find(params[:job_id])
    @job_product = JobProduct.find(params[:job_product_id])
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
