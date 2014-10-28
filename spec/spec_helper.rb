ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'capybara/rspec'
require 'selenium-webdriver'
#require 'capybara/rails'

#Capybara.javascript_driver = :webkit

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.include Capybara::DSL

  # config.mock_with :rspec do |c|
  #   c.syntax = [:should, :expect]
  # end
  # config.expect_with :rspec do |c|
  #   c.syntax = [:should, :expect]
  # end

  config.use_transactional_fixtures = false

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # config.infer_spec_type_from_file_location!



  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
  

  Capybara.javascript_driver = :selenium

end
