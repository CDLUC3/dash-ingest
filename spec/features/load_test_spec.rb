#require 'spec_helper'
require 'selenium-webdriver'
require 'rspec-expectations'


include RSpec::Matchers


# browser = Selenium::WebDriver.for :chrome
# browser.get "http://dash-dev.cdlib.org"

# # Timeout = 15 sec
# wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# # puts "Test Passed:" if wait.until {
# #   browser.find_element(:xpath => "/html/body/div/div/section[2]/div[1]/div[1]/a").click
# #
# # }
# CampusLink = browser.find_element(:link, "UC Berkeley")
# CampusLink.click

# FollowLink  = browser.find_element(:link, "My Datasets")
# FollowLink.click



# Login.click
# #browser.quit

# Selenium selenium = new DefaultSelenium("localhost", 4444, "*firefox", "https://dash-stg.cdlib.org/")

def setup
  @driver = Selenium::WebDriver.for(
    :remote,
    url: 'http://localhost:4444/wd/hub',
    desired_capabilities: :chrome) # you can also use :chrome, :safari, firefox, etc.
  @username = ''
  @password = ''
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  # @driver.get 'https://dash-stg.cdlib.org/'
  # expect(@driver.title).to eq('Dash: Data submission')
  # @driver.get 'https://dash-stg.ucop.edu/'
  # @driver.find_element(link: 'My Datasets').click
  # @driver.find_element(id: 'j_username').send_keys "@username"
  # @driver.find_element(id: 'j_password').send_keys "@password"
  # @driver.find_element(id: 'Login').click

  @driver.get 'localhost:3000'

  @driver.find_element(id: 'new_record').click
  @driver.find_element(id: 'record_title').send_keys "test"


  drop_down_list = @driver.find_element(id: 'record_resourcetype')

  select_list = Selenium::WebDriver::Support::Select.new(drop_down_list)
  select_list.select_by(:value, "Collection,Collection")

  @driver.find_element(id: 'record_creators_attributes_0_creatorName').send_keys "auth1"
  @driver.find_element(id: 'save_and_continue').click

  @driver.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")
  
  filename = 'selenium_test_spec.rb'
  file = File.join(Dir.pwd, filename)
  
  
  @driver.find_element(id: 'upload_upload').send_keys file
  


# scenario 'uploads file if file is present' , :js => true do 
#     page.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")
#     file = Rails.root + "app/assets/images/dash_cdl_logo.png"
#     attach_file('upload_upload', file)
#     click_on 'start_button'
#     expect(page).to have_css('#delete_button')
#     click_on 'submit_button'

#     expect(page).to have_content 'Review Before Submitting'  
#   end


end

















