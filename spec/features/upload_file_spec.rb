require 'spec_helper'
require 'database_cleaner'
require 'selenium-webdriver'

# browser = Selenium::WebDriver.for :chrome
# browser.get "localhost:3000"


feature 'user uploads file' do


	before(:each) do
    
    institution = FactoryGirl.create(:institution)
    institution.abbreviation = 'UC'
    institution.short_name = 'UC Office of the President'
    institution.long_name = 'University of California, Office of the President'
    institution.landing_page = '.ucop.edu'
    institution.external_id_strip = '.*@.*ucop.edu$'
    institution.campus = 'cdl'
    institution.logo = 'blank_institution_logo.png'
    institution.shib_entity_id = 'urn:mace:incommon:ucop.edu'
    institution.shib_entity_domain = 'ucop.edu'
  	institution.save


  	user = FactoryGirl.create(:user)
  	user.first_name = "Test"
  	user.last_name = "User"
    user.external_id = 'Fake.User@ucop.edu'
  	user.institution_id = institution.id
  	user.save

    visit root_path
    click_link 'new_record'
    fill_in 'record_title', :with => 'Rose' 
    select 'Image', :from => 'record_resourcetype' 
    fill_in 'record_creators_attributes_0_creatorName', :with => 'Test User' 
    click_on "save_and_continue"
    
  end


  scenario 'triggers validation error if file is not present' , :js => true do 
    page.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")
    file = Rails.root + "app/assets/images/dash_cdl_logo.png"
    attach_file('upload_upload', file)
    click_on 'submit_button'

    expect(page).not_to have_content 'Review Before Submitting'  
	end


  scenario 'uploads file if file is present' , :js => true do 
    page.execute_script("$('span.fileinput-button').removeClass('fileinput-button');")
    file = Rails.root + "app/assets/images/dash_cdl_logo.png"
    attach_file('upload_upload', file)
    click_on 'start_button'
    expect(page).to have_css('#delete_button')
    click_on 'submit_button'

    expect(page).to have_content 'Review Before Submitting'  
  end

end