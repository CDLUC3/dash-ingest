class LoginController < ApplicationController

  include RecordHelper

  
  def index
    if current_user
      redirect_to '/records'
    end
  end


  def logout
    if current_user
      @institution = current_user.institution
    end
    session[:user_id] = nil
    cookies.delete(:dash_logged_in)
    @user = nil
    @current_user = nil
    @institution = nil
    
    # cookies.delete(:'_jquery-fileupload-rails-example_session')
    redirect_to logout_page_path
  end
  
  
  def login_page
  end
  

  def logout_page
    render :layout => false
    @institution = institution
  end


  def access_denied
    render :layout => false
  end
  

end




