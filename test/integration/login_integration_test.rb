# require 'test_helper'
# require "capybara/rails"

# class Login_integration_Test < ActiveSupport::TestCase
  
#   include Capybara::DSL
  
#   # setup do
#   # end
  
#   # teardown do
#   # end
  
#   # only used in development
#   # in production, covered with shib or other external
#   # login system which sets the session credentials
#   test "login and login without credentials" do  
#     visit '/records'    
            
#     assert page.has_content?("My Datasets")
#   end
  
#   # also only used in development
#   test "logout page" do
#     visit '/logout'
#     assert page.has_content?("You are now logged out.")
#   end
  
  
# end