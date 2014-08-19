source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '3.2.19'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'
gem 'mysql2'
gem 'rubyzip',  "~> 0.9.9"

group :development, :local do
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'webrick', '~> 1.3.1'
  gem 'byebug'
  gem 'sextant' #you can go to http://localhost:3000/rails/routes to see routes
end

group :test do
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'sqlite3'
  gem 'database_cleaner'
end

gem 'whenever', :require => false



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-fileupload-rails'
gem 'paperclip'
gem 'twitter-bootstrap-rails', '2.1.7'
gem 'less-rails', '2.3.3'
gem 'honeypot-captcha'
gem 'strong_parameters'
gem "omniauth-google-oauth2", "~> 0.2.1"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'
gem 'carrierwave'
gem 'custom_error_message', '~> 1.1.1'


