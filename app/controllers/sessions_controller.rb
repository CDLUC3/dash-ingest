class SessionsController < ApplicationController
  def create

    user = User.from_omniauth(env["omniauth.auth"],session['institution_id'])
    session[:user_id] = user.id
    session[:institution_id]= user.institution_id
    #logger.debug "Params: #{session}"

    redirect_to records_path, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    session[:institution_id] = nil
    #logger.debug "Params: #{session}"
    reset_session
    redirect_to logout_page_path
  end


  def signin
    #logger.info "Params=#{params}"
    if !params[:institution_id].blank?
      session['institution_id'] = params[:institution_id]
    end
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


  def institution

    url = request.original_url
    if ( url == nil )
      @id = ""
    else
      case url.strip
        when /.ucop.edu/
          @id = 1
        else
          @id = 12
      end
    end
    return @id
  end


end

