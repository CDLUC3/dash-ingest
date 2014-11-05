OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do


  provider :google_oauth2, APP_CONFIG['client_id'], APP_CONFIG['client_secret'], {provider_ignores_state: true}

  OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:omniauth_failure).call(env)
  #this will invoke the omniauth_failure action in SessionsController.
end


end

