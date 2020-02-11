class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :setup_search

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cell_phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:cell_phone])
  end

  private

  def setup_search
    @q ||= Job.ransack(params[:q])
  end

  def all_clients
  	@all_clients ||= Client.order("name").all
  end
  helper_method :all_clients

  def all_states
  	@all_states ||= State.order("name").all
  end
  helper_method :all_states

  def active_states
    @active_states ||= State.active
  end
  helper_method :active_states

end
