require 'uri'
class SessionsController < ApplicationController


  def create

    logger.debug "SHIB_FORWARD " + "#{env["HTTP_X_FORWARDED_SERVER"]}"
    new_url = env["HTTP_X_FORWARDED_SERVER"].to_s

    if new_url.split(",")[0] == "dash.ucla.edu"
      new_url = new_url.split(",")[1]
    end

    logger.info "SHIB_NEW #{new_url.inspect}"

    Institution.all.each do |i|
      if Regexp.new(i.external_id_strip).match(new_url)
        @institution = i
        logger.info  "INS  #{@institution.inspect}"
      end
    end

    session[:institution_id] = @institution.id
    
    if ENV["RAILS_ENV"] == "local" || ENV["RAILS_ENV"] == "test"
      user = User.find_by_external_id("Fake.User@ucop.edu")
    else

      # user = User.from_omniauth(env["omniauth.auth"],session['institution_id'])
      user = User.from_omniauth(env["omniauth.auth"], @institution.id)
    end
    session[:user_id] = user.id
    # session[:institution_id]= user.institution_id
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
        domain = @institution.shib_entity_domain
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
    uri = URI(request.base_url)
    uri = uri.to_s if uri
    # logger.info "uriabcdefg #{uri.inspect} "
    Institution.all.each do |i|
      if Regexp.new(i.external_id_strip).match(uri) 
        return i
      end
    end 
  end


end
























