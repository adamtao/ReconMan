class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :setup_search

  private

  def setup_search
    @q ||= Job.search(params[:q])
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
