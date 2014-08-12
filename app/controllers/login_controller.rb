class LoginController < ApplicationController

  include RecordHelper
  
  def login
    user = User.find_by_external_id(request.headers[DATASHARE_CONFIG['external_identifier']])
    
    if user.nil?
      user = User.new
      user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
      user.save
    end

    if user.institution_id.nil?
    end

    session[:user_id] = user.id
    set_session_institution(user.external_id)
    

    redirect_to "/records"
  end
  



  def logout
    if @user
      set_session_institution(@user.external_id)
      @institution = Institution.find_by_id(session[:institution_id])
    end
    redirect_to logout_page_path
  end
  
  
  # login and logout pages aren't used in prod
  # shib will protect the directory
  # these methods are available for runnign theapp
  # in dev without shib or another authentication system
  def login_page
  end
  
  def logout_page
    @user = User.find_by_id(session[:user_id])
    if !@user
      login and return
    end
    set_session_institution(@user.external_id)
    @institution = Institution.find_by_id(session[:institution_id])
    @campus = url_to_campus
    render :layout => false
  end
  
end
