Rails.application.config.middleware.use OmniAuth::Builder do
  opts = YAML.load_file(File.join(Rails.root, 'config', 'shibboleth.yml'))[Rails.env]
  provider :shibboleth, opts.symbolize_keys
  DataIngest::Application.shibboleth_host = opts['host']
end