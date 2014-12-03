# require 'spec_helper'
require 'selenium-webdriver'
require 'rspec-expectations'


include RSpec::Matchers


def setup

  @driver = Selenium::WebDriver.for :chrome
  @driver.get "https://dash-dev.ucop.edu/xtf/search"

  users = YAML.load_file("spec/support/features/credentials.yml")
  @username = users[ucop]
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


def wait_for(seconds)
  Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
end


run do
  
  @driver.find_element(link: 'My Datasets').click
  @driver.find_element(id: 'j_username').send_keys @username
  @driver.find_element(id: 'j_password').send_keys @password
  @driver.find_element(id: 'Login').click


  @driver.find_element(id: 'new_record').click
  @driver.find_element(id: 'record_title').send_keys "test"

  drop_down_list = @driver.find_element(id: 'record_resourcetype')

  select_list = Selenium::WebDriver::Support::Select.new(drop_down_list)
  select_list.select_by(:value, "Collection,Collection")

  @driver.find_element(id: 'record_creators_attributes_0_creatorName').send_keys "auth1"
  @driver.find_element(id: 'save_and_continue').click

  @driver.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")
  
  # filename = 'selenium_test_spec.rb'
  # file = File.join(Dir.pwd, filename)
  
  @driver.find_element(id: 'upload_upload').send_keys "/spec/features/selenium_test_spec.rb"
  # @driver.find_element(id: 'upload_upload').send_keys "/spec/features/selenium_test_spec.rb"

  @driver.find_element(id: 'start_button').click

  wait_for(10) { @driver.find_element(id: 'delete_button').displayed? }

  @driver.find_element(id: 'submit_button').click
  


#     expect(page).to have_content 'Review Before Submitting'  


end

















