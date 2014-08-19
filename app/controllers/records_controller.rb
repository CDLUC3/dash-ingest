class RecordsController < ApplicationController

  include RecordHelper
  before_filter :verify_ownership
  #before_save :update_creator

# GET list all records
  def index
    @user = current_user
    if !@user || !@user.institution_id
      redirect_to login_path and return
    end
    
    @institution = @user.institution
    #@records = Record.find_all_by_user_id(@user.id)
    @records = Record.find_all_by_user_id(current_user.id)
  end

  # GET form for new record
  def new
     @user = current_user
     @institution = @user.institution
     @record = Record.new
     @record.creators.build()
     @record.citations.build
     
     3.times do
      @record.subjects.build
     end
     @record.publisher = @institution.short_name
     @record.rights = "Creative Commons Attribution 4.0 International (CC-BY 4.0)"
     @record.rights_uri = "https://creativecommons.org/licenses/by/4.0/"
  end

  # POST - create new record
  def create
    @record = Record.new(params[:record])
    @user = current_user
    @record.user_id = @user.id
    @institution = @user.institution
    @record.set_local_id

    @record.publisher = @institution.short_name if @record.publisher.blank?
    @record.institution_id = @user.institution_id
    @record.creators.build() if @record.creators.blank?
    @record.citations.build() if @record.citations.blank?

    @record.subjects.build() if @record.subjects.blank?

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
    3.times do
      @record.subjects.build() if @record.subjects.blank?
    end

    #@record = Record.find(params[:id])
    if @record.rights.nil?
      @record.rights = "Creative Commons Attribution 4.0 International (CC-BY 4.0)"
      @record.rights_uri = "https://creativecommons.org/licenses/by/4.0/"
    end
    @record.creators.build() if @record.creators.blank?
    @record.citations.build()if @record.citations.blank?
    @record.subjects.build() if @record.subjects.blank?
    if @record.subjects.count() == 1
      2.times do
        @record.subjects.build()
      end
    elsif @record.subjects.count() == 2
      1.times do
        @record.subjects.build()
      end
    end

  end


  def delete
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to records_path
  end


  def update
    @user = current_user
    @institution = @user.institution
    @record = Record.find(params[:id])
    if !@record.institution_id
      @record.institution_id = @user.institution_id
    end
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
    :id, :title, :resourcetype, :publisher, :rights, :rights_uri,
    creators_attributes: [ :id, :record_id, :creatorName, :_destroy],
    subjects_attributes: [ :id, :record_id, :subjectName, :_destroy],
    citation_attributes: [ :id, :record_id, :citationName, :_destroy])

  end


 


  def review
    @user = current_user
    @institution = @user.institution
    @record = Record.find(params[:id])
    @record.purge_temp_files
    @xmlout = @record.review   
    render :review, :layout => false
  end



  public
  def send_archive_to_merritt
    @user = current_user
    @institution = @user.institution
    @record = Record.find(params[:id])
    if !@record.required_fields.empty?
      render :action => "review", :id => @record.id
    else    
      @merritt_response = "PROCESSING"

      # processing of large files can take a long time
      # so we will handle this in a separate thread

      @user_email = request.headers[DATASHARE_CONFIG['user_email_from_shibboleth']]
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

    @user = current_user
    @record = Record.find_by_id(params[:id])
    if @user
      @institution = @user.institution
    end

    if !@user.nil? && !@record.nil?
      if @record.user_id != @user.id
        # redirect_to "/records"
        render "/records"
      end
    end
  end
  
    

  
  def submission_log
    @user = current_user
    if @user
      @institution = @user.institution
    end
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
