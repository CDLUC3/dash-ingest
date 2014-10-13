require 'uri'
class SessionsController < ApplicationController
  def create
     byebug
     if ENV["RAILS_ENV"] == "local"
       user = User.find_by_id(36)
       #user = User.find_by_external_id("Fake.USer@ucop.edu")
     else
      user = User.from_omniauth(env["omniauth.auth"],session['institution_id'])
       end
    session[:user_id] = user.id
    session[:institution_id]= user.institution_id
    cookies[:dash_logged_in] = 'Yes'

    logger.debug "Params: #{session}"

    redirect_to records_path, notice: "Signed in!"
  end

  def destroy

    session[:user_id] = nil
    session[:institution_id] = nil
    cookies.delete(:dash_logged_in)
    #logger.debug "Params: #{session}"
    reset_session
    redirect_to logout_page_path
  end


  def signin
    #logger.info "Params=#{params}"
   uri = URI(request.original_url)
   if uri.host == "localhost"
    redirect_to sessions_create_path and return

    # if !params[:institution_id].blank?
    #   session['institution_id'] = params[:institution_id]
    # end
   else
    @institution = Institution.find(institution)
    session['institution_id']= @institution.id
    if !@institution.shib_entity_domain.blank?
      #initiate shibboleth login sequence
      redirect_to OmniAuth::Strategies::Shibboleth.login_path_with_entity(
                      DataIngest::Application.shibboleth_host, @institution.shib_entity_id)
    elsif @institution.shib_entity_domain.blank?
      redirect_to "/auth/google_oauth2"
    end

  end
end

  def institution

    uri = URI(request.original_url)

   if uri.host == "localhost"
     @id = Institution.find(1)
     return @id.id
   else
       url = uri.host.split(".")
       l = url.length
       u = ".#{url[l-2]}.#{url[l-1]}"

      @id = Institution.find_by_landing_page(u)

      return @id.id



  end

  end

  # url = request.original_url
  # if ( url == nil )
  #   @id = ""
  # else
  #   case url.strip
  #     when /.ucop.edu/
  #       @id = 1
  #     else
  #       @id = 12
  #   end
  # end
  # return @id

  end