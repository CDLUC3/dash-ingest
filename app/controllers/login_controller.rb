class LoginController < ApplicationController

  include RecordHelper
  
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
    redirect_to "/records"
  end
  

  def logout
    if @user
      @institution = @user.institution
    end
    session[:user_id] = nil
    redirect_to logout_page_path
  end
  
  
  # login and logout pages aren't used in prod
  # shib will protect the directory
  # these methods are available for runnign theapp
  # in dev without shib or another authentication system
  def login_page
  end
  
  def logout_page
    render :layout => false
  end
  
end
