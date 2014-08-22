require 'spec_helper'
require 'database_cleaner'

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