OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do


  provider :google_oauth2, APP_CONFIG['client_id'], APP_CONFIG['client_secret'], {provider_ignores_state: true}


end

