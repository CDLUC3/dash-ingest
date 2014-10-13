class RecordsController < ApplicationController

  include RecordHelper

  before_filter :verify_ownership

  # before_filter :test, only: :review


  def test
    byebug
  end



    def index


      if current_user
        @user = current_user
        @institution = @user.institution
        @records = Record.find_all_by_user_id(current_user.id)


      else
        redirect_to :controller => 'sessions', :action => 'signin'  #:institution_id => params[:institution_id]
      end

    end


    # GET form for new record
  def new
    if ENV["RAILS_ENV"] == "test"
      @user = User.find_by_external_id("Fake.User-ucop.edu@ucop.edu")
      session[:user_id] = @user.id
    end
    @user = current_user
    @institution = @user.institution
    @record = Record.new
    @record.creators.build()
    @record.citations.build()

    3.times do
      @record.subjects.build()
    end
    @record.publisher = @institution.short_name
    @record.rights = "Creative Commons Attribution 4.0 International (CC-BY 4.0)"
    @record.rights_uri = "https://creativecommons.org/licenses/by/4.0/"
  end

  
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
    3.times do
      @record.subjects.build() if @record.subjects.blank?
    end

    if @record.subjects.count() == 0
      2.times do
        @record.subjects.build()
      end
    end

    if @record.save
      unless @user.last_name.nil? || @user.last_name.blank?
        @contributor = Contributor.new(record_id: @record.id,
                                       contributorType: "DataManager",
                                       contributorName: @user.last_name + ", " + @user.first_name)
        @contributor.save
      end
      if @funder = params[:record][:funder]
        @contributor = Contributor.new(record_id: @record.id,
                                       contributorType: "Funder",
                                       contributorName: @funder)
        @contributor.save
      end

      if @grant_number = params[:record][:grant_number]
        @description = Description.new(record_id: @record.id,
                                       descriptionType: "Other",
                                       descriptionText: @grant_number)
        @description.save
      end

      if params[:commit] == 'Save'
        redirect_to edit_record_path(@record.id)
      elsif params[:commit] =='Save And Continue'
        redirect_to "/record/#{@record.id}/uploads", :record_id => @record.id
      end
    else
      render "new"
    end
  end


  def edit
    @record = Record.find(params[:id])
    @description = @record.grant_number
    @grant_number = @record.grant_number
    @record.creators.build() if @record.creators.blank?
    @record.citations.build() if @record.citations.blank? || @record.citations.nil?
    3.times do
      @record.subjects.build() if @record.subjects.blank?
    end
    if @record.subjects.count() == 0
      2.times do
        @record.subjects.build()
      end

    elsif @record.subjects.count() == 2
      1.times do
        @record.subjects.build()
      end
    elsif @record.subjects.count() == 1
      2.times do
        @record.subjects.build()

      end
    end
    if @record.rights.nil?
      @record.rights = "Creative Commons Attribution 4.0 International (CC-BY 4.0)"
      @record.rights_uri = "https://creativecommons.org/licenses/by/4.0/"
    end
   
  end

#deletes also one contributor
  def delete
    @record = Record.find(params[:id])
    @contributor = Contributor.find_all_by_record_id(@record.id).first

    uploads = @record.uploads
    uploads.each do |u| 
      file_path = "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{u.record.local_id}"
      if File.exist?("#{file_path}")
         # FileUtils.rm_rf Dir.glob("#{file_path}/*")
         # FileUtils.rm_rf("#{file_path}/*")
         FileUtils.remove_dir("#{file_path}")
      end
    end  

    @contributor.destroy if @contributor
    @record.destroy
    redirect_to records_path
  end


  def update

    @user = current_user
    @institution = @user.institution
    @record = Record.find(params[:id])
    @record.creators.build() if @record.creators.blank?
    #@record.citations.build() if @record.citations.length < 1
    @record.subjects.build() if @record.subjects.blank?

    if @record.subjects.count() == 0
      2.times do
        @record.subjects.build()
      end
    elsif @record.subjects.count() == 2
      1.times do
        @record.subjects.build()
      end
    elsif @record.subjects.count() == 1
      2.times do
        @record.subjects.build()
      end
    end

    @record.institution_id = @user.institution_id unless @record.institution_id

    if @record.update_attributes(record_params)
      @funder = params[:record][:funder] 

      if !@funder.nil? && !@funder.blank?
        if @record.funder
          @contributor = @record.contributors.where(contributorType: 'Funder').find(:first)
          @contributor.update_attributes(contributorName: @funder)
          @contributor.save
        else
          @contributor = Contributor.new(record_id: @record.id,
                                       contributorType: "Funder",
                                       contributorName: @funder)
          @contributor.save
        end
      elsif @record.funder
        @contributor = @record.contributors.where(contributorType: 'Funder').find(:first)
        @contributor.destroy
      end


      @grant_number = params[:record][:grant_number] 

      if !@grant_number.nil? && !@grant_number.blank?
        if @record.grant_number
          @description = @record.descriptions.where(descriptionType: 'Other').find(:first)
          @description.update_attributes(descriptionText: @grant_number)
          @description.save
        else
          @description = Description.new(record_id: @record.id,
                                       descriptionType: "Other",
                                       descriptionText: @grant_number)
          @description.save
        end
      elsif @record.grant_number
        @description = @record.descriptions.where(descriptionType: 'Other').find(:first)
        @description.destroy
      end


      if params[:commit] =='Save And Continue'
        redirect_to "/record/#{@record.id}/uploads", :record_id => @record.id
      elsif params[:commit] == 'Save'
        redirect_to edit_record_path(@record.id)
      else
        render 'edit'
      end

    else
      render 'edit'
    end

  end


  private

  def record_params
    params.require(:record).permit(
        :id, :title, :resourcetype, :publisher, :rights, :rights_uri, :methods, :abstract, 
        creators_attributes: [ :id, :record_id, :creatorName, :_destroy],
        subjects_attributes: [ :id, :record_id, :subjectName, :_destroy],
        citations_attributes: [ :id, :record_id, :citationName, :_destroy, :related_id_type, :relation_type],
        contributors_attributes: [:id, :record_id, :contributorType, :contributorName],
        descriptions_attributes: [:id, :record_id, :descriptionType, :descriptionText])
  end

   


public


  def review

    @user = current_user
    @institution = @user.institution
    @record = Record.find(params[:id])

    if @record.submissionLogs.empty? || @record.submissionLogs.nil?
      @new_submission = true
    else
      @log_length = @record.submissionLogs.length
      @array_position = @log_length - 1
      @first_submission = @record.submissionLogs[@array_position].filtered_response.to_s.include?("Success") ? false : true
    end

    @record.purge_temp_files
    @xmlout = @record.review

  end


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

      # sleep(5)

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
      # render :action => "submission_log", :id=> @record.id  
      redirect_to logs_path(@record.id)
    end

  end


  def verify_ownership

    # if ENV["RAILS_ENV"] == "test"
    #   @user = User.find_by_external_id("Fake.User-ucop.edu@ucop.edu")
    #   session[:user_id] = @user.id
    # else
    @user = current_user
    # end

    @record = Record.find_by_id(params[:id])
    if @user
      @institution = @user.institution
    end
    
    if !@user.nil? && !@record.nil?
      if @record.user_id != @user.id
        redirect_to "/records"
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
