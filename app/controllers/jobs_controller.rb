class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @q = Job.search(params[:q])
    @jobs = @q.result(distinct: true)
    if @jobs.length == 1
      redirect_to @jobs.first
    else
      @current_jobs = @jobs.where.not(workflow_state: "complete").joins(:job_products).limit(100)
      @completed_jobs = @jobs.where(workflow_state: "complete").limit(25)
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @comment = Comment.new(related_type: "Job", related_id: @job.id)
  end

  # GET /jobs/new
  def new
    @job = Job.new
    if params[:client_id]
      @job.client_id = params[:client_id]
    end
    if params[:job_type]
      @job.job_type = params[:job_type]
      @job.initialize_job_products
    end
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    @job.creator = current_user
    @job.job_products.each do |jp|
      jp.creator = current_user
      jp.worker ||= current_user
      jp.payoff_amount_cents ||= 0
    end
    respond_to do |format|
      if @job.save
        @job.job_products.each{ |jp| jp.set_price }
        format.html {
          if params[:commit].to_s.match(/save.*new/i)
            redirect_to new_job_path(client_id: @job.client_id, job_type: @job.job_type), notice: 'Job was successfully created. Create another one below...' 
          else
            redirect_to @job, notice: 'Job was successfully created.'
          end
        }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    @job.modifier = current_user
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:parcel_number,
        :client_id, :address, :city, :state_id, :zipcode, :county_id, :old_owner, :new_owner, :requestor_id,
        :file_number, :close_on, :beneficiary_name, :payoff_amount, :beneficiary_account, :underwriter_name,
        :short_sale, :file_type, :job_type, :parcel_legal_description, :deed_of_trust_number, :developer,
        job_products_attributes: [
          :product_id,
          :_destroy,
          :deed_of_trust_number,
          :lender_id,
          :beneficiary_name,
          :beneficiary_account,
          :payoff_amount,
          :developer,
          :price,
          :parcel_number,
          :parcel_legal_description,
          :new_deed_of_trust_number,
          :recorded_on
          ]
        )
    end

end
