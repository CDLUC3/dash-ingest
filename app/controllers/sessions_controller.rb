require 'uri'
class SessionsController < ApplicationController


    def create

      logger.debug "ENV #{env.inspect}"
      #logger.debug "#{env["HTTP_SHIB_IDENTITY_PROVIDER"]}"
      #logger.debug params.inspect

      if params[:provider] == "shibboleth"
        shib_id = "#{env["HTTP_SHIB_IDENTITY_PROVIDER"]}"
        shib_provider = shib_id.split(':')
        shib_campus = ".#{shib_provider.last}"
        @institution = Institution.find_by_landing_page(shib_campus)
      else
        # we are authenticating via google so the domain is cdlib.org
        @institution = Institution.find_by_landing_page(".cdlib.org")
      end

      session['institution_id'] = @institution.id
      if ENV["RAILS_ENV"] == "local" || ENV["RAILS_ENV"] == "test"
        user = User.find_by_external_id("Fake.User@ucop.edu")
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
    session[:user_id] = nil
    session[:institution_id] = nil
    cookies.delete(:dash_logged_in)

    uri = URI(request.original_url)
    # if uri.host == "localhost"
    if ENV["RAILS_ENV"] == "test" || ENV["RAILS_ENV"] == "local"
       redirect_to sessions_create_path and return
    else
      # grab the institution from the domain URL
      @institution = institution
      session['institution_id']= @institution.id

      if !@institution.shib_entity_domain.blank?
        #initiate shibboleth login sequence
        domain = @institution.landing_page
        redirect_back_to_hostname = DataIngest::Application.shibboleth_host + domain
        logger.debug "Shib Host Redirected to " + redirect_back_to_hostname
        redirect_to OmniAuth::Strategies::Shibboleth.login_path_with_entity(
                        redirect_back_to_hostname,
                        @institution.shib_entity_id)
      else
        logger.debug "google Host Redirected to google_auth2"
        redirect_to "/auth/google_oauth2"
      end
    end
  end

  def institution
    uri = URI(request.original_url)
    url = uri.host.split(".")
    l = url.length
    u = ".#{url[l-2]}.#{url[l-1]}"

    @institution = Institution.find_by_landing_page(u)
    return @institution
  end

end


