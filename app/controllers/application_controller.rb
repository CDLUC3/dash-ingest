class ApplicationController < ActionController::Base
  protect_from_forgery

  include RecordHelper

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end


end





















