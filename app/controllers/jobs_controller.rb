class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @q = Job.ransack(params[:q])
    @jobs = @q.result(distinct: true).page(params[:page])
    if @jobs.length == 1 && !@jobs.first.new_record?
      redirect_to @jobs.first
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    if @job.county.checkout_expired_for?(current_user)
      @job.county.expire_checkout!
      redirect_to root_path, alert: "Checkout for #{@job.county.name} county expired. Please start again." and return false
    elsif @job.county.checked_out_to == current_user
      @job.county.renew_checkout
    end
    @comment = Comment.new(related_type: "Job", related_id: @job.id)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /jobs/file_number/:id
  # GET /jobs/file_number/:id.json
  def file_number
    @job = nil
    if jobs = Job.where(file_number: params[:id])
      @job = jobs.last
    end
    respond_to do |format|
      format.html { redirect_to @job }
      format.json { render action: :show }
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
    if params[:client_id]
      @job.client_id = params[:client_id]
    end
    if params[:job_type]
      @job.job_type = params[:job_type]
      @job.initialize_tasks
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
    @job.tasks.each do |task|
      if @job.job_type.present?
        task.type = "#{@job.job_type.to_s.singularize.capitalize}Task"
      end
      task.creator = current_user
      task.worker ||= current_user
      task.payoff_amount_cents ||= 0
    end
    respond_to do |format|
      if @job.save
        @job.tasks.each{ |task| task.set_price }
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
      format.html { redirect_to client_path(@job.client), notice: 'Job was successfully destroyed.' }
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
        tasks_attributes: [
          :id,
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
          :recorded_on,
          :docs_delivered_on,
          lender_attributes: [ :name ]
          ]
        )
    end

end
