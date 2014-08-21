if File.exist?(File.join(Rails.root, 'config', 'app_config.yml'))
  env = YAML.load_file(File.join(Rails.root, 'config', 'app_config.yml'))[Rails.env]

  #this if allows for indirection and have one environment reference another if it is the same then it's a simple string
  #people were trying to use the indirection feature for the config, but it wasn't implemented here

  if env.class == String
    APP_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'app_config.yml'))[env]
  else
    APP_CONFIG = env
  end
    CAMPUS_EMAILS = YAML.load_file(File.join(Rails.root, 'config', 'app_config.yml'))['campus_emails']
end