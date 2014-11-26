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
  # @driver.get 'https://dash-stg.cdlib.org/'
  # expect(@driver.title).to eq('Dash: Data submission')
  # @driver.get 'https://dash-stg.ucop.edu/'
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

  # @driver.find_element(id: 'Login').click
  # @driver.find_element(id: 'Login').click
end

















