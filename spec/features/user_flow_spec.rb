require 'spec_helper'
require 'database_cleaner'
# require "selenium-webdriver"

feature 'user flow' do

	scenario 'homepage' do

	# before(:all) do
    
    institution = FactoryGirl.create(:institution)
  	institution.save

  	user = FactoryGirl.create(:user)
  	user.first_name = "John"
  	user.last_name = "Smith"
  	user.institution_id = institution.id
  	user.save

    visit '/records'
    
  # end
	end

  # feature "home page" do 
	  
	  scenario 'displays users datasets' do
	  	institution = FactoryGirl.create(:institution)
	  	institution.save

	  	user = FactoryGirl.create(:user)
	  	user.first_name = "John"
	  	user.last_name = "Smith"
	  	user.institution_id = institution.id
	  	user.save

	    visit '/records'
	    visit root_path

	    expect(page).to have_content 'My Datasets'   
	  end

	# end


	# feature "adding new dataset" do 
	  
	  scenario 'goes to the new dataset page' do
	  	institution = FactoryGirl.create(:institution)
	  	institution.save

	  	user = FactoryGirl.create(:user)
	  	user.first_name = "John"
	  	user.last_name = "Smith"
	  	user.institution_id = institution.id
	  	user.save
	   	visit '/records/new'
			#puts page.html
     	expect(page).to have_content "Describe Your Dataset"
	  end


	  scenario 'adds record metadata with valid attributes' do
	  	institution = FactoryGirl.create(:institution)
	  	institution.save

	  	user = FactoryGirl.create(:user)
	  	user.first_name = "John"
	  	user.last_name = "Smith"
	  	user.institution_id = institution.id
	  	user.save

	  	visit root_path
	  	click_link 'new_record'

	  	#visit '/records/new'
	  	#save_and_open_page

	  	fill_in 'record_title', :with => 'Rose' 
    	select 'Image', :from => 'record_resourcetype' 
    	fill_in 'record_creators_attributes_0_creatorName', :with => 'John Smith' 

    	click_on "save_and_continue"
    	# puts page.html
		end
	  
	# end



end