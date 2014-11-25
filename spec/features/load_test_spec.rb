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


# UserName = browser.find_element(:id, "username")
# UserName.send_keys ""
# Password = browser.find_element(:id, "password")
# Password.send_keys ""

# Login = browser.find_element(:class, "button")
# Login.click
# #browser.quit

# Selenium selenium = new DefaultSelenium("localhost", 4444, "*firefox", "https://dash-stg.cdlib.org/")

def setup
  @driver = Selenium::WebDriver.for(
    :remote,
    url: 'http://localhost:4444/wd/hub',
    desired_capabilities: :chrome) # you can also use :chrome, :safari, firefox, etc.
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
  @driver.get 'https://dash-stg.cdlib.org/'
  expect(@driver.title).to eq('Dash: Data submission')
  @driver.find_element(css: '#UC Office of the President').click
end
