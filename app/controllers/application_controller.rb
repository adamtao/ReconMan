class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def all_clients
  	@all_clients ||= Client.order("name").all
  end
  helper_method :all_clients

  def all_states
  	@all_states ||= State.order("name").all
  end
  helper_method :all_states
  
end
