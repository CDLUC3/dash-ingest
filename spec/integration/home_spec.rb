require 'spec_helper'

describe 'home page' do
  it 'displays users datasets' do

  	institution = FactoryGirl.create(:institution)
  	institution.save

  	user = FactoryGirl.create(:user)
  	user.first_name = "John"
  	user.last_name = "Smith"
  	user.institution_id = institution.id
  	user.save

    visit '/records'
    page.should have_content('My Datasets')
  end
end