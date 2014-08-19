# require 'test_helper'
# require "capybara/rails"

# class Contact_Us_integration_Test < ActiveSupport::TestCase
  
#   include Capybara::DSL
  
#   setup do
#     FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
#     Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}")
#     Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890")
#     FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890/datacite.xml")
    
#     Capybara.current_session.driver.header 'eppn', 'abc123'
    
#     visit '/login'
#   end
  
#   teardown do
#     FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
#   end
  
#   test "send message with success" do  
#     visit '/contact'             
#     assert page.has_content?("Contact Us")
    
#     fill_in "name", :with => "Joe"
#     fill_in "affiliation", :with => "Oxford"
#     fill_in "email", :with => "test@test.edu"
#     fill_in "message", :with => "How are you?"
#     click_button "Submit"
#     assert page.has_content?("Your email message was sent to the Dash team.")
#   end

#   test "send message with incorrect data" do  
#     visit '/contact'             
#     click_button "Submit"
#     assert page.has_content?("Please enter your name")
#     assert page.has_content?("Please enter your email")
#     assert page.has_content?("Please enter a message")

#     fill_in "name", :with => "Joe"
#     click_button "Submit"
#     assert page.has_content?("Please enter your email")
#     assert page.has_content?("Please enter a message")
    
#     fill_in "name", :with => "Joe"
#     fill_in "affiliation", :with => "Oxford"
#     fill_in "message", :with => "How are you?"
#     click_button "Submit"
#     assert page.has_content?("Please enter your email")

#     fill_in "name", :with => "Joe"
#     fill_in "affiliation", :with => "Oxford"
#     fill_in "email", :with => "test"
#     fill_in "message", :with => "How are you?"
#     click_button "Submit"
#     assert page.has_content?("Please enter a valid email address")

#     fill_in "name", :with => "Joe"
#     fill_in "affiliation", :with => "Oxford"
#     fill_in "email", :with => "test@test.edu"
#     click_button "Submit"
#     assert page.has_content?("Please enter a message")

#   end

# end























