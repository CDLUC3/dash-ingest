# require 'spec_helper'
require 'selenium-webdriver'
require 'rspec-expectations'
require 'yaml'



include RSpec::Matchers


def setup

  @driver = Selenium::WebDriver.for :firefox
  @driver.get "https://dash-dev.ucop.edu/xtf/search"
  @driver.get "localhost:3000/records"

  users = YAML.load_file("spec/support/features/credentials.yml")
  @username = users['ucop']['USERNAME']
  @password = users['ucop']['PASSWORD']

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
  # @driver.find_element(id: 'j_username').send_keys @username
  # @driver.find_element(id: 'j_password').send_keys @password
  # @driver.find_element(id: 'Login').click
  @driver.find_element(id: 'new_record').click
  @driver.find_element(id: 'record_title').send_keys "LOAD_TEST"

  drop_down_list = @driver.find_element(id: 'record_resourcetype')

  select_list = Selenium::WebDriver::Support::Select.new(drop_down_list)
  select_list.select_by(:value, "Collection,Collection")

  @driver.find_element(id: 'record_creators_attributes_0_creatorName').send_keys "auth1"
  @driver.find_element(id: 'save_and_continue').click
  @driver.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")

  # @driver.find_element(id: 'upload_upload').click

  # filename = File.dirname(__FILE__) + "/selenium-test_spec.rb"


  filename = File.join(File.expand_path(File.dirname(__FILE__)), "selenium-test_spec.rb")

  # @driver.find_element(:xpath, "//*[@id=\"upload_upload\"]").clear
  # @driver.find_element(:xpath, "//*[@id=\"upload_upload\"]").send_keys filename

  puts filename
  
  @driver.find_element(id: 'upload_upload').send_keys filename

  @driver.find_element(id: 'start_button').click

  wait_for(20) { @driver.find_element(id: 'delete_button').displayed? }

  @driver.find_element(id: 'submit_button').click
  
  expect(@driver.find_element(css: 'h1').text).to eql 'Review Before Submitting'

end

















