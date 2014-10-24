OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

 APP_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'app_config.yml'))[Rails.env]

  provider :google_oauth2, APP_CONFIG['client_id'], APP_CONFIG['client_secret'], {provider_ignores_state: true}

  #provider :google_oauth2, '97385814132-omb3h8so0fhsb82lr7klerm9pl8mr8is.apps.googleusercontent.com', 'TavWNTcyVkl3hUm8kvkKNGo0',{provider_ignores_state: true}



end

