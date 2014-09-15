require 'omniauth'
OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = "http://localhost:3000"

Rails.application.config.middleware.use OmniAuth::Builder do
  opts = YAML.load_file(File.join(Rails.root, 'config', 'shibboleth.yml'))[Rails.env]
  provider :shibboleth, opts
  DataIngest::Application.shibboleth_host = opts['host']
end