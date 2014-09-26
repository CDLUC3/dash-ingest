class LoginController < ApplicationController

  include RecordHelper

  def signin
    #logger.info "Params=#{params}"
    if !params[:institution_id].blank?
      session['id'] = params[:institution_id]
    elsif session['id'].blank?
    #redirect_to login_path, flash: {error: 'Please choose your log in institution.'} and return
  end
  @institution = Institution.find(params[:institution][:institution_id])
  if @institution.shib_entity_domain.blank?
    #initiate shibboleth login sequence
    redirect_to OmniAuth::Strategies::Shibboleth.login_path_with_entity(
                    DataIngest::Application.shibboleth_host, @institution.shib_entity_id)
  else
    #just let the original form render
  end


#if ENV["RAILS_ENV"] == "test"
# user = User.find_by_external_id("Fake.User-ucop.edu@ucop.edu")
#user.save
#else
# user = User.find_by_external_id(request.headers[DATASHARE_CONFIG['external_identifier']])


#if user.nil?
# user = User.new
#end

#user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
#user.institution_id = User.institution_from_shibboleth(request.headers[DATASHARE_CONFIG['external_identifier']]).id
#user.email = request.headers[DATASHARE_CONFIG['user_email_from_shibboleth']]
#user.first_name = request.headers[DATASHARE_CONFIG['first_name_from_shibboleth']]
#user.last_name = request.headers[DATASHARE_CONFIG['last_name_from_shibboleth']]
#user.save


# if user.institution_id.nil?
#   user.institution_id = User.institution_from_shibboleth(request.headers[DATASHARE_CONFIG['external_identifier']]).id
#   user.save
# end

# if user.email.nil?
#   user.email = request.headers[DATASHARE_CONFIG['user_email_from_shibboleth']]
#   user.save
# end

# if user.first_name.nil? || user.first_name.blank?
#   user.first_name = request.headers[DATASHARE_CONFIG['first_name_from_shibboleth']]
#   user.last_name = request.headers[DATASHARE_CONFIG['last_name_from_shibboleth']]
# end


#session[:user_id] = user.id
#cookies[:dash_logged_in] = 'Yes'
#@current_user = user
#redirect_to "/records"
end

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



# helper_method :current_user,  :require_login

#   protected

#     def current_user
#       @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
#     end

#     def require_login
#       if session[:user_id].blank?
#         flash[:error] = "You must be logged in to access this page."
#         session[:return_to] = request.original_url
#         redirect_to choose_institution_path and return
#       end
#     end

#     #require that a user is logged out
#     def require_logout
#       if session && !session[:user_id].blank?
#         flash[:error] = "The page you're trying to access is only available to logged out users."
#         redirect_to dashboard_path and return
#       end
#     end
