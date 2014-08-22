require 'spec_helper'
require 'database_cleaner'
# require "selenium-webdriver"

feature 'user uploads file' do


	before(:each) do
    
    institution = FactoryGirl.create(:institution)
  	institution.save

  	user = FactoryGirl.create(:user)
  	user.first_name = "John"
  	user.last_name = "Smith"
  	user.institution_id = institution.id
  	user.save

    visit root_path
    click_link 'new_record'
    fill_in 'record_title', :with => 'Rose' 
    select 'Image', :from => 'record_resourcetype' 
    fill_in 'record_creators_attributes_0_creatorName', :with => 'John Smith' 
    click_on "save_and_continue"
    
  end


  scenario 'triggers validation error if file is not present' , :js => true do
    # puts page.html
  	# click_on 'upload_upload'
    # attach_file('upload_upload', '/Users/sfaenza/Desktop/dash-images/rose.jpg')
    page.find("#upload_upload").trigger("click")
    # select "rose.jpg"
    # save_and_open_page
    # click_on 'start_button'
    # click_on 'submit_button'
	end



end