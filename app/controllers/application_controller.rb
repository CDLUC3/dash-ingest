class ApplicationController < ActionController::Base
  protect_from_forgery

  #helper_method  :institution_external_id
  include RecordHelper

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login
    user = User.find_by_external_id(request.headers[DATASHARE_CONFIG['external_identifier']])
    
    if user.nil?
      user = User.new
      user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
      user.institution_id = User.institution_from_shibboleth(request.headers[DATASHARE_CONFIG['external_identifier']]).id
      user.save
    end

    if user.institution_id.nil?
      user.institution_id = User.institution_from_shibboleth(request.headers[DATASHARE_CONFIG['external_identifier']]).id
      user.save
    end

    session[:user_id] = user.id
    @current_user = user
    redirect_to "/records"
  end



end





















