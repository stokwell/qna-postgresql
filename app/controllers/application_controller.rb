class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  def gon_user
    gon.user_id = current_user.id if current_user
  end

end
