require "rails_helper"

describe RecordsController do
  render_views

  before(:all) do
    @user = FactoryGirl.create(:user )
    @institution = FactoryGirl.create(:institution)
    puts @institution.id
    #puts @institution.logo
    puts @user.id
  end

  describe "GET index" do
    it "has a 200 status code" do
      get(:index, {}, {user_id: @user.id})
      expect(response.status).to eq(200)
    end

    #it "should redirect on index page" do
    #get(:index, {}, {user_id: @user.id})
    #expect(response).to redirect_to(records_path)

    #end
  end

  describe "GET new"
    it "assigns a new record as @records" do
      #visit records_new_path(:id => @user.id)
      get(:new, {}, {user_id: @user.id})
      #get :new, :id => @user.id
      assigns(:record).should be_a_new(Record)
    end
  end

  describe "POST create" do

  before(:each) do
    @record = FactoryGirl.create(:record, :title => "sss", :identifierType => "nil", :identifier => "nil",  :publisher => "UC Office of the president",
                                 :publicationyear =>"2014",:resourcetype => "Image,Image",:rights => "Creative Commons Attribution 4.0 International (CC-...",
                                 :created_at => "2014-08-11 19:31:52",:updated_at => "2014-08-11 19:31:52",:local_id =>"uzkmimntnn", :rights_uri => "https://creativecommons.org/licenses/by/4.0/")
    @record.user_id = @user.id
    puts @record.id
    @record.save
    @record_attributes = FactoryGirl.attributes_for(:record, :record_id => @record.id)
    @creator_attributes = FactoryGirl.attributes_for(:creator, :record_id => @record.id)
    @subject_attributes = FactoryGirl.attributes_for(:subject, :record_id => @record.id)
    @citation_attributes = FactoryGirl.attributes_for(:citation,:record_id => @record.id)

  end

  it "should create new record " do
    post :create , :record => @record_attributes
  end


end