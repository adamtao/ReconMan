# TODO: re-enable authentication/authorization, in fact add it to all controllers

class UsersController < ApplicationController
  #before_filter :authenticate_user!
  #after_action :verify_authorized

  def index
    @users = User.all
    # authorize User
  end

  # Only called from parent client
  def new
    @user = User.new
    # authorize @user
    if params[:client_id]
      @client = Client.find(params[:client_id])
      @user.role = :client
    end
  end

  def create
    @user = User.new(create_params) 
    # authorize @user
    if @user.save
      @user.confirm!
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
    # authorize @user
  end

  def update
    @user = User.find(params[:id])
    # authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    # authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end

  def create_params
    params.require(:user).permit(:name, :email, :role, :branch_id, :password, :password_confirmation)
  end

end
