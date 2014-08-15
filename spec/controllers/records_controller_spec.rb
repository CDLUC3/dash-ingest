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


  def valid_attributes

    {:title => "sss", :identifierType => "nil", :identifier => "nil",  :publisher => "UC Office of the president",
        :publicationyear =>"2014",:resourcetype => "Image,Image",:rights => "Creative Commons Attribution 4.0 International (CC-...",
        :created_at => "2014-08-11 19:31:52",:updated_at => "2014-08-11 19:31:52",:local_id =>"uzkmimntnn", :rights_uri => "https://creativecommons.org/licenses/by/4.0/"}

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

  describe "GET new" do
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
    @creator = FactoryGirl.create(:creator, :creatorName => "xcv")
    @creator.save
    @subject = FactoryGirl.create(:subject)
    @user = FactoryGirl.create(:user )
    @record.user_id = @user.id
    puts @record.id
    @record.save
    @record_attributes = FactoryGirl.attributes_for(:record, :record_id => @record.id)
    @creator_attributes = FactoryGirl.attributes_for(:creator, :record_id => @record.id)
    @subject_attributes = FactoryGirl.attributes_for(:subject, :record_id => @record.id)
    @citation_attributes = FactoryGirl.attributes_for(:citation,:record_id => @record.id)

  end

  it "should create new record " do
    post :create, :record => @record_atrributes, user_id: @user.id
    assigns(:record).should be_a(Record)
    #expect(response).to redirect_to(Record.last)
  end
  end



    describe "GET show" do
      it "assigns the requested record as @record" do
      @record =  Record.create! valid_attributes
      get :show, :id => @record.id, user_id: @user.id
      expect(response.status).to  eq(200)


    end
  end


  describe "GET edit" do
    it "assigns the requested record as @record" do
      @record = Record.create! valid_attributes
      get :edit, :id => @record.id, user_id: @user.id
      assigns(:record).should be_a(Record)
  end
  end

=begin describe "PUT update" do
    describe "with valid params" do
      it "updates the requested record" do
        @record = Record.create! valid_attributes


        Record.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @record.id, :record => {'these' => 'params'}}, user_id: @user.id
      end

      it "assigns the requested record as @record" do
        @record = Record.create! valid_attributes
        put :update, {:id => @record.id, :record => valid_attributes}, user_id: @user.id
        assigns(:record).should eq(record)
      end

      it "redirects to the record" do
        @record = Record.create! valid_attributes
        put :update, {:id => @record.id, :record => valid_attributes}, user_id: @user.id
        response.should redirect_to(record)
      end
    end
  end
=end

   describe 'PUT update' do
     before :each do

       @record = valid_attributes

     end

     context "valid attributes" do
       it "located the requested @record" do
         put :update, id: @record.id, record: valid_attributes, user_id: @user.id
         assigns(:record).should eq(@record)
       end
     end
   end


end