class JobProductsController < ApplicationController
  before_action :set_job, except: :toggle_billing
  before_action :set_job_product, only: [:show, :edit, :update, :toggle, :toggle_billing, :destroy, :research]

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
    @job_product.lender = Lender.new
  end

  # GET /job_products/1/edit
  # TODO: The edit form (html) has a separate copy of the form.
  # The reason has to do with the fancy javascript in the create form
  # which shows/hides fields based on the select job type. This was
  # causing problems in the form. The correct way to do it is to
  # insert/remove those fields instead of showing/hiding them.
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
    search_log = build_search_log
    respond_to do |format|
      if @job_product.update(job_product_params)
        if job_product_params[:search_url] && !@job_product.search_url.blank?
          search_log.save
        elsif job_product_params[:new_deed_of_trust_number] && job_product_params[:recorded_on]
          if @job_product.search_logs.length > 0
            search_log = @job_product.search_logs.last
          end
          search_log.status = "Cleared"
          search_log.save
        end
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

  # POST /job_products/:id/toggle_billing
  def toggle_billing
    @job_product.update_column(:billed, !@job_product.billed?)
    render nothing: true
  end

  # GET /job/:job_id/job_product/:id/research
  def research
    if @job_product.search_url.present?
      redirect_to @job_product.search_url
      build_search_log.save
    else
      redirect_to @job, notice: "The search URL is missing. Provide it below."
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

    def build_search_log
      SearchLog.new(
        status: "Not Cleared",
        job_product: @job_product,
        user: current_user
      )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_product_params
      params.require(:job_product).permit(:product_id, :search_url,
          :worker_id,
          :due_on,
          :deed_of_trust_number,
          :beneficiary_name,
          :beneficiary_account,
          :payoff_amount,
          :developer,
          :price,
          :parcel_number,
          :parcel_legal_description,
          :new_deed_of_trust_number,
          :recorded_on,
          lender_attributes: [ :name ]
        )
    end
end
