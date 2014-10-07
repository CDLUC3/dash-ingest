class LoginController < ApplicationController

  include RecordHelper

  # def signin
  #   #logger.info "Params=#{params}"
  #   if !params[:institution_id].blank?
  #     session['institution_id'] = params[:institution_id]
  #   end
  #   @institution = Institution.find(institution)
  #   session['institution_id']= @institution.id
  #   if !@institution.shib_entity_domain.blank?
  #     #initiate shibboleth login sequence
  #     redirect_to OmniAuth::Strategies::Shibboleth.login_path_with_entity(
  #                     DataIngest::Application.shibboleth_host, @institution.shib_entity_id)
  #   elsif @institution.shib_entity_domain.blank?
  #     redirect_to "/auth/google_oauth2"
  #   end
  #
  # end
  #
  #
  # def institution
  #
  #   url = request.original_url
  #   if ( url == nil )
  #     @id = ""
  #   else
  #     case url.strip
  #       when /.ucop.edu/
  #         @id = 1
  #       else
  #         @id = 12
  #     end
  #   end
  #   return @id
  # end



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
