class RecordsController < ApplicationController


  before_filter :verify_ownership

# GET list all records
  def index
    @user = User.find_by_id(session[:user_id])
    if !@user
      login and return
    end
    @records = Record.find_all_by_user_id(session[:user_id])
  end

  # GET form for new record
  def new
   @user = User.find(session[:user_id])
   @campus_short_name = campus_short_name(@user)
   @record = Record.new
   @record.creators.build()
   @record.citations.build
   #3.times do
   @record.subjects.build
   #end
   @record.publisher = campus_short_name(@user)
  end

  # POST - create new record
  def create
    @record = Record.new(params[:record])
    @record.user_id = session[:user_id]
    @record.set_local_id
    @record.publisher = campus_short_name(@user) if @record.publisher.blank?
    @record.creators.build() if @record.creators.blank?
    @record.citations.build() if @record.citations.blank?
    @record.subjects.build() if @record.subjects.blank?

=begin
    @record.user_id = session[:user_id]
    @record.set_local_id
    @record.id = (params[:id])
    @record.publisher = campus(@user)
    @record.title = (params[:title])
    @record.resourcetype = (params[:resourcetype])
    @record.methods = (params[:methods])
    @record.abstract = (params[:abstract])
    #@record.citations = params[:citations]
    #@creator = Creator.new(:creatorName => params[:creator_name])
=end
        if @record.save
        if params[:commit] == 'Save'
        redirect_to "/records/show"
        elsif params[:commit] =='Save And Continue'
        redirect_to "/record/#{@record.id}/uploads"
        end

     else
      render "new"
    end
  end


   def show
   @records = Record.find_all_by_user_id(session[:user_id])
 end

def edit

  @record = Record.find(params[:id])
  @record.creators.build() if @record.creators.blank?
  @record.citations.build() if @record.citations.blank?
  @record.subjects.build() if @record.subjects.blank?


end


  def delete

    @record = Record.find(params[:id])
    @record.delete

    redirect_to records_path

  end



  def update

    @record = Record.find(params[:id])
    if @record.update_attributes(record_params)
      #redirect_to  @record
  if params[:commit] == 'Save'
        redirect_to "/records/show"
      elsif params[:commit] =='Save And Continue'
        redirect_to "/record/#{@record.id}/uploads"
  end
    else
      render 'edit'
  end

  end

  private
  def record_params
    params.require(:record).permit(
    :id, :title, :resourcetype, :publisher,
    creators_attributes: [ :id, :record_id, :creatorName, :_destroy],
    subjects_attributes: [ :id, :record_id, :subjectName, :_destroy],
    citation_attributes: [ :id, :record_id, :citationName, :_destroy])

    end


  #this is really for both save and update
=begin  def update_record
    
    @campus_short_name = campus_short_name(@user)
    @record = Record.find(params[:id])
    @record.title = params[:title]
    @record.publisher = @campus_short_name
    #@record.publisher = @campus_full_name
    #@record.publisher = @campus
    @record.publicationyear = params[:publicationyear]
    @record.resourcetype = params[:resourcetype]
    @record.rights = params[:rights]
    @record.abstract = params[:abstract]
    @record.methods = params[:methods]
    @record.save
        
    if !params[:creator_name].empty?
      creator = Creator.new
      creator.creatorName = params[:creator_name]
      creator.record_id = @record.id
      creator.save
    end
    
    if !params[:contributor_name].to_s.empty?
      
      # no duplicate contributor names
      if !@record.contributors.pluck(:contributorName).include? params[:contributor_name]
      
        contributor = Contributor.new
        contributor.contributorName = params[:contributor_name]
        contributor.contributorType = params[:contributor_type]
        contributor.record_id = @record.id
        contributor.save
      end
    end
    
    if !params[:subject_name].empty?
      subject2 = []
      subject3 = []
      subject1 = params[:subject_name].split(",")
      subject2 = (params[:subject_name2].split(",")) unless params[:subject_name2].empty?
      subject3 = (params[:subject_name3].split(",")) unless params[:subject_name3].empty?
      
      # subjects = params[:subject_name].split(",")
      subjects = subject1 + subject2 + subject3
      
      subjects.each do |s|
        subject = Subject.new
        subject.subjectName = s
        #scheme is optional and open, not currently used
        #subject.subjectScheme = params[:subject_scheme]
        subject.record_id = @record.id
        subject.save
      end
    end
    
    if !params[:citation].empty?
      description = Description.new
      description.descriptionText = params[:citation]
      #scheme is optional and open, not currently used
      #subject.subjectScheme = params[:subject_scheme]
      description.record_id = @record.id
      description.save
    end
    
  
    if params[:add_data] == "Save And Continue"
      render :js => "window.location = '/record/#{@record.id}/uploads'"
    else
      # redirect_to :action => "record", :id=> @record.id
      render :action => "record", :id=> @record.id
    end
  end

=end



=begin def destroy

     Record.find(params[:id]).destroy
     flash[:notice] = "Record Deleted Successfully!"
     redirect_to records_path
end
=end

=begin  def delete
    @record = Record.find(params[:id])
    
    # because we don't have separate controllers, we have to 
    # do this manually rather than rely on cascade approaches
    # in the model
    Creator.delete_all(:record_id => @record.id)
    Contributor.delete_all(:record_id => @record.id)
    Subject.delete_all(:record_id => @record.id)
    Upload.delete_all(:record_id => @record.id)
    Description.delete_all(:record_id => @record.id)
    SubmissionLog.delete_all(:record_id => @record.id)
    
    file_path = "#{Rails.root}/uploads/#{@record.local_id}"
    
    if File.exists?("#{file_path}")
       FileUtils.rm_rf("#{file_path}")
    end
    
    @record.delete
    redirect_to "/records"
    # render "/records"
  end  
    
  def delete_creator
    @creator = Creator.find(params[:creator_id])
    @record = @creator.record
    @creator.delete
    # redirect_to :action => "record", :id=> @record.id, :anchor => "creator"
    render :action => "record", :id=> @record.id, :anchor => "creator"
  end
  
  # currently this is hard wired into the app, only one contributor per record
  # no need for 1:n delete, but leaving the code in if we make this change later
  #def delete_contributor
  #  contributor = Contributor.find(params[:contributor_id])
  #  @record = contributor.record
  #  contributor.delete
  #  redirect_to :action => "record", :id=> @record.id, :anchor => "contributor"
  #end
  
  def delete_description
    description = Description.find(params[:description_id])
    @record = description.record
    description.delete
    # redirect_to :action => "record", :id=> @record.id, :anchor => "description"
    render :action => "record", :id=> @record.id, :anchor => "description"
  end
  
  def delete_subject
    subject = Subject.find(params[:subject_id])
    @record = subject.record
    subject.delete
    # redirect_to :action => "record", :id=> @record.id, :anchor => "subject"
    render :action => "record", :id=> @record.id, :anchor => "subject"
  end
=end



  def review
    @record = Record.find(params[:id])
    
    @record.purge_temp_files
    
    @xmlout = @record.review
    
    render :review, :layout => false
  end

  public
  def send_archive_to_merritt
    @record = Record.find(params[:id])
    
    if !@record.required_fields.empty?
      # redirect_to :action => "review", :id => @record.id
      render :action => "review", :id => @record.id
    else    
      
      @merritt_response = "PROCESSING"

      # processing of large files can take a long time
      # so we will handle this in a separate thread
      
      Thread.new do
        @record.generate_merritt_zip

        @merritt_request = @record.send_archive_to_merritt (@user.external_id)

        submissionLog = SubmissionLog.new

        if (!@merritt_request)
          @merritt_response = "User not authorized for Merritt submission"
      	else
          @merritt_response = `#{@merritt_request}`
	      end

        submissionLog.archiveresponse = @merritt_response
        submissionLog.record = @record
        submissionLog.save
         # if the submission was successful, remove the files from local
          # storage and add logging information
        if !(submissionLog.filtered_response == "Failed")
          @record.purge_files(submissionLog.id)
        end
        ActiveRecord::Base.connection.close
      end

      sleep(5)

      submissionLog = SubmissionLog.new

      # if it has taken more than 5 seconds to process, we will create an intermediary
      # entry to inform the user that the upload is still processing
      # this message will appear when the user is forwarded to the submission log page
      if @merritt_response == "PROCESSING"
            submissionLog.archiveresponse = @merritt_response
            submissionLog.record = @record
            submissionLog.save
      end
      
      # redirect_to :action => "submission_log", :id=> @record.id   
      render :action => "submission_log", :id=> @record.id   
    end
    
  end


  def verify_ownership
    @user = User.find_by_id(session[:user_id])
    @record = Record.find_by_id(params[:id])

    if !@user.nil? && !@record.nil?
      if @record.user_id != @user.id
        # redirect_to "/records"
        render "/records"
      end
    end
  end
  
    

  
  def submission_log
    @record = Record.find_by_id(params[:id])
  end
  
  def terms_of_use
  end
  
  def prepare_to_submit
  end
  
  def upload_faq_page
  end
  
  def metadata_basics
  end
  
  def steps_to_publish
  end
  
  def data_use_agreement
  end
  
end
