require 'spec_helper'
require 'selenium-webdriver'

browser = Selenium::WebDriver.for :chrome
browser.get "http://dash-dev.cdlib.org"

# Timeout = 15 sec
wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# puts "Test Passed:" if wait.until {
#   browser.find_element(:xpath => "/html/body/div/div/section[2]/div[1]/div[1]/a").click
#
# }
CampusLink = browser.find_element(:link, "UC Berkeley")
CampusLink.click

FollowLink  = browser.find_element(:link, "My Datasets")
FollowLink.click


UserName = browser.find_element(:id, "username")
UserName.send_keys "cstrasser"
Password = browser.find_element(:id, "password")
Password.send_keys "J3anm1che7"

Login = browser.find_element(:class, "button")
Login.click
#browser.quit
