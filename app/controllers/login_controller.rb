class LoginController < ApplicationController
  
  def login
    user = User.find_by_external_id(request.headers[DATASHARE_CONFIG['external_identifier']])
    
    if user.nil?
      user = User.new
      user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
      user.save
    end

    session[:user_id] = user.id

    redirect_to "/records"
  end
  



  def logout
    #reset_session
    redirect_to logout_page_path
  end
  
  # login and logout pages aren't used in prod
  # shib will protect the directory
  # these methods are available for runnign theapp
  # in dev without shib or another authentication system
  def login_page
  end
  
  def logout_page
    @campus = url_to_campus
    render :layout => false
  end
  
end
