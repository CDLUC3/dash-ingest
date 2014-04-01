class RecordsController < ApplicationController
  
  before_filter :verify_ownership
  
  def index
    @user = User.find_by_id(session[:user_id])
    @records = Record.find_all_by_user_id(session[:user_id])
  end
  
  def record
    @user = User.find(session[:user_id])
    if(params[:id])
      @record = Record.find(params[:id])
    else
      @record = Record.new
      @record.user_id = session[:user_id]
      @record.set_local_id
      @record.save
      @record.create_record_directory
    end
  end
  
  def update_record    
    @record = Record.find(params[:id])
    @record.title = params[:title]
    @record.publisher = params[:publisher]
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
    
    if !params[:contributor_name].empty?
      
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
      
      subjects = params[:subject_name].split(",")
      
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
    
  
    if params[:add_data] == "add_data"
      render :js => "window.location = '/record/#{@record.id}/uploads'"
    else
      redirect_to :action => "record", :id=> @record.id
    end
  end
    
  def delete
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
  end  
    
  def delete_creator
    @creator = Creator.find(params[:creator_id])
    @record = @creator.record
    @creator.delete
    redirect_to :action => "record", :id=> @record.id, :anchor => "creator"
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
    redirect_to :action => "record", :id=> @record.id, :anchor => "description"
  end
  
  def delete_subject
    subject = Subject.find(params[:subject_id])
    @record = subject.record
    subject.delete
    redirect_to :action => "record", :id=> @record.id, :anchor => "subject"
  end
  
  def review
    @record = Record.find(params[:id])
    
    @record.purge_temp_files
    
    @xmlout = @record.review
    
    render :review, :layout => false
  end
  
  def send_archive_to_merritt
    @record = Record.find(params[:id])
    
    if !@record.required_fields.empty?
      redirect_to :action => "review", :id => @record.id
    else    
      
      @merritt_response = "PROCESSING"

      # processing of large files can take a long time
      # so we will handle this in a separate thread
      
      Thread.new do
        @record.generate_merritt_zip
        @merritt_request = @record.send_archive_to_merritt
        @merritt_response = `#{@merritt_request}`
        submissionLog = SubmissionLog.new
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
      
      redirect_to :action => "submission_log", :id=> @record.id   
    end
    
  end
  
    
  def verify_ownership 
    @user = User.find_by_id(session[:user_id])
    @record = Record.find_by_id(params[:id])
    
    if !@user.nil? && !@record.nil?
      if @record.user_id != @user.id
        redirect_to "/records"
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
