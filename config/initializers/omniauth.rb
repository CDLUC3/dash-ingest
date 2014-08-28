OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '97385814132-omb3h8so0fhsb82lr7klerm9pl8mr8is.apps.googleusercontent.com', 'TavWNTcyVkl3hUm8kvkKNGo0'
end