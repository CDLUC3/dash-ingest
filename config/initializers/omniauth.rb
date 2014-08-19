OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '97385814132-igqkrtm2gsi79c05v1ijefvfrkfgq4u6.apps.googleusercontent.com', ' izRsMXlQ0x5ow2jsRiGlrK7T', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end