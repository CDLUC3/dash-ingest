# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DataIngest::Application.initialize!

MERRITT_CONFIG = YAML.load_file("#{Rails.root}/config/merritt.yml")[Rails.env]
DATASHARE_CONFIG = YAML.load_file("#{Rails.root}/config/datashare.yml")[Rails.env]