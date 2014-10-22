require 'spec_helper'
require 'database_cleaner'
# require "selenium-webdriver"

feature 'user' do


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

    visit '/records'
    
  end
	
	  
  scenario 'goes to the home page' do
    visit root_path

    expect(page).to have_content 'My Datasets'   
  end

 
  scenario 'goes to the new dataset page' do
  	visit root_path
  	click_link 'new_record'
		
   	expect(page).to have_content "Describe Your Dataset"
  end


  scenario 'triggers validation errors if required attributes are missing when adding a new record' do
  	visit root_path
  	click_link 'new_record' 
  	click_on "save_and_continue"
  	
  	expect(page).to have_content "Please specify the data type."
  	expect(page).to have_content "You must include a title for your submission."
  	expect(page).to have_content "You must add at least one creator."
	end


  scenario 'adds record metadata with valid attributes' do
  	visit root_path
  	click_link 'new_record'
  	fill_in 'record_title', :with => 'Rose' 
  	select 'Image', :from => 'record_resourcetype' 
  	fill_in 'record_creators_attributes_0_creatorName', :with => 'John Smith' 
  	click_on "save_and_continue"

  	expect(page).to have_content "Upload Your Dataset"
	end


	scenario 'Sends email through Contact Us page.' do
    click_on "Contact Us"

    expect(page).to have_selector('h1', text: 'Contact Us') 
    
    fill_in 'name', :with => 'Test Email'
    fill_in 'affiliation', :with => 'UCOP'
    fill_in 'email', :with => 'test@test.edu'
    fill_in 'message', :with => 'This is an automated test for the contact us page.'

    click_on "Submit"

    assert !ActionMailer::Base.deliveries.empty?

    expect(page).to have_content "Your email message was sent to the Dash team."
  end


	scenario 'logs out' do
    click_on "Log Out"

    expect(page).to have_content 'You are now logged out.' 
    expect(page).not_to have_content 'Log Out'

    click_on 'Return to Home'
  end


end