class CountiesController < ApplicationController
  before_action :set_state, except: [:checkin, :checkout]
  before_action :set_county, only: [:show, :edit, :update, :checkin, :checkout, :destroy]

  # GET /counties
  # GET /counties.json
  def index
    @counties = @state.counties
  end

  # GET /counties/1
  # GET /counties/1.json
  def show
    @current_jobs = @county.current_jobs.paginate(page: params[:page], per_page: 20)
  end

  # GET /counties/new
  def new
    @county = County.new(state: @state)
  end

  # GET /counties/1/edit
  def edit
  end

  # POST /counties
  # POST /counties.json
  def create
    @county = County.new(county_params)
    @county.state = @state
    respond_to do |format|
      if @county.save
        format.html { redirect_to [@state, @county], notice: 'County was successfully created.' }
        format.json { render :show, status: :created, location: @county }
      else
        format.html { render :new }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /counties/1
  # PATCH/PUT /counties/1.json
  def update
    respond_to do |format|
      if @county.update(county_params)
        format.html { redirect_to [@state, @county], notice: 'County was successfully updated.' }
        format.json { render :show, status: :ok, location: @county }
      else
        format.html { render :edit }
        format.json { render json: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /counties/:id/checkout
  def checkout
    current_user.checkout_county(@county)
    if @county.current_jobs.length > 0
      redirect_to @county.current_jobs.first
    else
      redirect_to [@county.state, @county]
    end
  end

  # PUT /counties/:id/checkin
  def checkin
    @county.expire_checkout!
    redirect_to root_path, notice: "The county has been checked in."
  end

  # DELETE /counties/1
  # DELETE /counties/1.json
  def destroy
    begin
      @county.destroy
      respond_to do |format|
        format.html { redirect_to @state, notice: 'County was successfully destroyed.' }
        format.json { head :no_content }
      end
    rescue => e
      redirect_to [@state, @county], alert: e
    end
  end

  private

    def set_state
      @state = State.find(params[:state_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_county
      @county = County.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def county_params
      params.require(:county).permit(:name, :state_id, :search_url, :search_params, :search_method, 
        :average_days_to_complete, :phone, :fax, :webpage, :contact_name, :contact_phone, :contact_email, 
        :assessor_webpage, :zip_codes, :co_fee_schedule, :simplifile, :s_contact_name, :s_contact_phone, 
        :s_contact_email)
    end
end
