class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.order("name").all
    authorize User
  end

  # Only called from parent client
  def new
    @user = User.new
    authorize @user
    if params[:client_id]
      @client = Client.find(params[:client_id])
      @user.role = :client
    end
  end

  def create
    @user = User.new(secure_params)
    # @user.skip_confirmation!
    authorize @user
    if @user.save
      if @user.branch
        redirect_to @user.branch.client, notice: "#{@user.name} created."
      else
        redirect_to @user, notice: "#{@user.name} created."
      end
    else
      if @user.branch_id
        @client = Branch.find(@user.branch_id).client
      end
      render action: 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    if @user.client?
      @current_jobs = @user.current_requested_jobs.page(params[:page])
      @completed_jobs = @user.requested_jobs.where(workflow_state: 'complete').order("updated_at DESC").limit(25)
    elsif @user.processor?
      @current_jobs = Job.dashboard_jobs(user: current_user, complete: false).page(params[:page])
      @completed_jobs = Job.dashboard_jobs(user: @user, fallback_to_all: false, complete: true, limit: 25)
    end
  end

  def edit
    @user = User.find(params[:id])
    @client = (@user.client) ? @user.client : Client.new
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    updates = secure_params.select{|k,v| v.present?}
    if @user.update_attributes!(updates)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:name, :email, :cell_phone, :role, :branch_id, :password, :password_confirmation,
      :primary_contact, :billing_contact, :phone)
  end

end
