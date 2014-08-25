class JobProductsController < ApplicationController
  before_action :set_job
  before_action :set_job_product, only: [:show, :edit, :update, :toggle, :destroy]

  # GET /job_products
  # GET /job_products.json
  def index
    @job_products = @job.job_products
  end

  # GET /job_products/1
  # GET /job_products/1.json
  def show
  end

  # GET /job_products/new
  def new
    @job_product = JobProduct.new(job: @job)
  end

  # GET /job_products/1/edit
  def edit
  end

  # POST /job_products
  # POST /job_products.json
  def create
    @job_product = JobProduct.new(job_product_params)
    @job_product.job = @job
    @job_product.creator = current_user
    respond_to do |format|
      if @job_product.save
        format.html { redirect_to @job, notice: 'Job product was successfully created.' }
        format.json { render :show, status: :created, location: @job_product }
      else
        format.html { render :new }
        format.json { render json: @job_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_products/1
  # PATCH/PUT /job_products/1.json
  def update
    @job_product.modifier = current_user
    respond_to do |format|
      if @job_product.update(job_product_params)
        format.html { redirect_to @job, notice: 'Job product was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_product }
      else
        format.html { render :edit }
        format.json { render json: @job_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /job/id/job_products/id/toggle.js
  def toggle
    @job_product.toggle!
    respond_to do |format|
      format.html { redirect_to @job, notice: "The #{@job_product.product.name} for this job is complete." }
      format.js { render nothing: true }
    end
  end

  # DELETE /job_products/1
  # DELETE /job_products/1.json
  def destroy
    @job_product.destroy
    respond_to do |format|
      format.html { redirect_to @job, notice: 'Job product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_job
      @job = Job.find(params[:job_id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_job_product
      @job_product = JobProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_product_params
      params.require(:job_product).permit(:product_id, :price, :search_url)
    end
end
