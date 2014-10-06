require 'rubygems'
require 'zip/zip'

class Record < ActiveRecord::Base
  include RecordHelper
  
  has_many :creators, :dependent => :destroy
  has_many :contributors, :dependent => :destroy
  has_many :descriptions
  has_many :subjects, :dependent => :destroy
  has_many :alternateIdentifiers
  has_many :datauploads
  has_many :relations
  has_many :submissionLogs
  has_many :uploads,   :dependent => :destroy
  has_many :citations, :dependent => :destroy
 

  attr_accessor :funder

 # accepts_nested_attributes_for :creators, allow_destroy: true
  belongs_to :user
  belongs_to :institution
  
  attr_accessible :identifier, :identifierType, :publicationyear, :publisher, 
                  :resourcetype, :rights, :rights_uri, :title, :local_id,:abstract, 
                  :methods, :funder


  
  
  validate :must_have_creators

  #the use of the symbol ^ is to avoid the column name to be displayed along with the error message, custom-err-msg gem
  validates_presence_of :title, :message => "^You must include a title for your submission."
  validates_presence_of :resourcetype, :message => "^Please specify the data type."
  validates_presence_of :rights, :message => "^Please specify the rights."
  validates_presence_of :rights_uri, :message => "^Please specify the rights URI."
  validates_presence_of :creators, :message => "^You must add at least one creator."

  before_save :mark_subjects_for_destruction, 
              :mark_citations_for_destruction, 
              :mark_creators_for_destruction

  accepts_nested_attributes_for :creators, allow_destroy: true, reject_if: proc { |attributes| attributes.all? { |key, value| key == '_destroy' || value.blank? } }
  attr_accessible :creators_attributes

  accepts_nested_attributes_for :citations, allow_destroy: true, reject_if: proc { |attributes| attributes.all? { |key, value| key == '_destroy' || value.blank? } }
  attr_accessible :citations_attributes

  accepts_nested_attributes_for :subjects, allow_destroy: true, reject_if: proc { |attributes| attributes.all? { |key, value| key == '_destroy' || value.blank? } }
  attr_accessible :subjects_attributes

  accepts_nested_attributes_for :contributors, allow_destroy: true, reject_if: proc { |attributes| attributes.all? { |key, value| key == '_destroy' || value.blank? } }
  attr_accessible :contributors_attributes
  


  def must_have_creators
    valid = 0
    if creators.nil?
      errors.add(:base, 'You must add at least one creator.')
    else
      creators.each do |creator|
        if !creator.creatorName.blank?
          valid = 1
        end
      end
      if valid == 0
        errors.add(:base, 'You must add at least one creator.')
      end
    end
  end


  def mark_subjects_for_destruction
    subjects.each {|subject|
    if subject.subjectName.blank?
      subject.mark_for_destruction
    end
    }
  end


  def mark_citations_for_destruction
    citations.each {|citation|
      if citation.citationName.blank?
        citation.mark_for_destruction
      end
    }
  end


  def mark_creators_for_destruction
    creators.each {|creator|
      if creator.creatorName.blank? || creator.creatorName == "" || creator.creatorName.nil?
        creator.mark_for_destruction
      end
    }
  end


  def set_local_id
    self.local_id = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
  end
  

  def create_record_directory
    FileUtils.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}")
  end
  
  def funder
    @funder = self.contributors.where(contributorType: 'Funder').find(:first)
    @funder[:contributorName] if @funder
  end


  def review

    @total_size = self.total_size
    @data_manager = self.contributors.where(contributorType: 'DataManager').find(:first)
    if @data_manager
      @data_manager_name = @data_manager.contributorName 
    else
      @data_manager_name = ""
    end
    # @funder = self.contributors.where(contributorType: 'Funder').find(:first)
    # if @funder
    #   @funder_name = @funder.contributorName 
    # else
    #   @funder_name = ""
    # end
    @funder_name = self.funder
    xml_content = File.new("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/datacite.xml", "w:ASCII-8BIT")
    
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.resource( 'xmlns' => 'http://datacite.org/schema/kernel-3', 
                    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                    'xsi:schemaLocation' => 'http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd') {
        xml.identifier('identifierType' => 'DOI') {}
        xml.creators{
          self.creators.each do |c|
            xml.creator {
              xml.creatorName "#{c.creatorName.gsub(/\r/,"")}"
            }
          end
        }
        xml.titles {
          xml.title "#{self.title}"
        }
        xml.pubisher "#{self.publisher}"
        xml.publicationYear "#{self.publicationyear}"
        xml.subjects {
          self.subjects.each do |s|
            xml.subject "#{s.subjectName.gsub(/\r/,"")}"
          end
        }
      
        xml.contributors {
          xml.contributor("contributorType" => "DataManager") {
            xml.contributorName @data_manager_name
          }
          xml.contributor("contributorType" => "Funder") {
            xml.contributorName @funder_name
          }
        }
        xml.resourceType("resourceTypeGeneral" => "#{resourceTypeGeneral(self.resourcetype)}") {
          xml.text("#{resourceTypeGeneral(self.resourcetype)}")
        }
        xml.size @total_size

        xml.rightsList { 
          xml.rights("rightsURI" => "#{CGI::escapeHTML(self.rights_uri)}") { 
            xml.text("#{CGI::escapeHTML(self.rights)}") 
          }
        }

        xml.descriptions{
          unless self.abstract.nil?
            xml.description("descriptionType" => "Abstract") { 
              xml.text("#{CGI::escapeHTML(self.abstract.gsub(/\r/,""))}")
            }
          end
          unless self.methods.nil?
            xml.description("descriptionType" => "Methods") {  
              xml.text("#{CGI::escapeHTML(self.methods.gsub(/\r/,""))}")
            }
          end
          self.descriptions.each do |d|
            xml.description("descriptionType" => "SeriesInformation") {  
              xml.text("#{CGI::escapeHTML(d.descriptionText.gsub(/\r/,""))}")
            }
          end
        }
      }
    end
    f = File.open("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/datacite.xml", 'w') { |f| f.print(builder.to_xml) }
    puts builder.to_xml.to_s
    builder.to_xml.to_s
   end


   def dublincore
    @total_size = self.total_size
    @data_manager = self.contributors.where(contributorType: 'DataManager').find(:first)
    if @data_manager
      @data_manager_name = @data_manager.contributorName 
    else
      @data_manager_name = ""
    end
    xml_content = File.new("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/dublincore.xml", "w:ASCII-8BIT")
    
    dc_builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.resource( 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                    'xsi:schemaLocation' => ' http://purl.org/dc/elements/1.1/ http://dublincore.org/schemas/xmls/qdc/2008/02/11/dc.xsd http://purl.org/dc/terms/ http://dublincore.org/schemas/xmls/qdc/2008/02/11/dcterms.xsd',
                    'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
                    'xmlns:dcterms' => 'http://purl.org/dc/terms/') {
        
        xml.identifier('identifierType' => 'DOI') {}
        xml.creators{
          self.creators.each do |c|
            xml.creator {
              xml.creatorName "#{c.creatorName.gsub(/\r/,"")}"
            }
          end
        }
        xml.titles {
          xml.title "#{self.title}"
        }
        xml.pubisher "#{self.publisher}"
        xml.publicationYear "#{self.publicationyear}"
        xml.subjects {
          self.subjects.each do |s|
            xml.subject "#{s.subjectName.gsub(/\r/,"")}"
          end
        }
      
        xml.contributors {
          xml.contributor("contributorType" => "DataManager") {
            xml.contributorName @data_manager_name
          }
        }
        xml.resourceType("resourceTypeGeneral" => "#{resourceTypeGeneral(self.resourcetype)}") {
          xml.text("#{resourceTypeGeneral(self.resourcetype)}")
        }
        xml.size @total_size

        xml.rightsList { 
          xml.rights("rightsURI" => "#{CGI::escapeHTML(self.rights_uri)}") { 
            xml.text("#{CGI::escapeHTML(self.rights)}") 
          }
        }

        xml.descriptions{
          unless self.abstract.nil?
            xml.description("descriptionType" => "Abstract") { 
              xml.text("#{CGI::escapeHTML(self.abstract.gsub(/\r/,""))}")
            }
          end
          unless self.methods.nil?
            xml.description("descriptionType" => "Methods") {  
              xml.text("#{CGI::escapeHTML(self.methods.gsub(/\r/,""))}")
            }
          end
          self.descriptions.each do |d|
            xml.description("descriptionType" => "SeriesInformation") {  
              xml.text("#{CGI::escapeHTML(d.descriptionText.gsub(/\r/,""))}")
            }
          end
        }
      }
    end
    f = File.open("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/dublincore.xml", 'w') { |f| f.print(dc_builder.to_xml) }
    puts dc_builder.to_xml.to_s
    dc_builder.to_xml.to_s
   end


   def total_size
    @total_size = 0
    self.uploads.each do |u|
      @total_size = @total_size + u.upload_file_size
    end
    if ( !self.submissionLogs.empty? && !self.submissionLogs.nil?)
      self.submissionLogs.each do |log|
          if ( !log.uploadArchives.empty? && !log.uploadArchives.empty?)
            log.uploadArchives.each do |a|
              @total_size = @total_size + a.upload_file_size.to_i     
            end
          end
      end
    end
    @total_size
   end


   def generate_merritt_zip  
    
     file_path = "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}"
    
     if File.exist?("#{file_path}/#{self.local_id}.zip")
       File.delete("#{file_path}/#{self.local_id}.zip")
     end
     
     zipfile_name = "#{file_path}/#{self.local_id}.zip"

     # target link and doi are generated by merritt
     # they are included here only for testing
     # uncomment if you need them in the archive (ie, if your repository does not supply these)
     f = File.new("#{file_path}/target_link", "w")  
     f.puts "http://localhost:3000/download_merritt_file/#{self.local_id}.zip"
     f.close

     f = File.new("#{file_path}/doi", "w")  
     f.puts "doi:10.7272/Q6057CV6"
     f.close

     File.open("#{file_path}/mrt-datacite.xml", "w") do |f|
        f.write self.review
     end

     File.open("#{file_path}/mrt-dc.xml", "w") do |f|
        f.write self.dublincore
     end


     Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|       
       zipfile.add("mrt-datacite.xml", "#{file_path}/mrt-datacite.xml")
       zipfile.add("mrt-dc.xml", "#{file_path}/mrt-dc.xml")
       
       self.purge_temp_files
       
       self.uploads.each do |d|  
          zipfile.add("#{d.upload_file_name}", "#{file_path}/#{d.upload_file_name}")
       end
     end

     # clean up all temp files (again, required because of the glitch in chunked file uploads)
     FileUtils.rm Dir[file_path + "/temp_*"]

   end


   # keep metadata records, but get rid of files that are no longer needed for local storate
   # (storage is intended only until records are uploaded to merritt)
   def purge_files(submission_log_id)
     
    uploads = Upload.find_all_by_record_id(self.id)
     
     # archive the file information for submission logs
    uploads.each do |u|
       upload_archive = UploadArchive.new
       upload_archive.submission_log_id = submission_log_id
       upload_archive.upload_file_name = u.upload_file_name
       upload_archive.upload_file_size = u.upload_file_size
       upload_archive.upload_content_type = u.upload_content_type
       upload_archive.save
     end
     
     Upload.delete_all(:record_id => self.id)

     file_path = "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}"

     # delete the files from local storage now that they have been submitted to merritt
     if File.exist?("#{file_path}")
       FileUtils.rm_rf Dir.glob("#{file_path}/*")
     end
   end


   def send_archive_to_merritt(external_id)
    
     # tics will execute, for now, just print to screen
      # note that the 2>&1 is to redirect sterr to stout

    @user = User.find_by_external_id(external_id)
    #@user = User.find(session[:user_id])

    if @user
      @user_email = @user.email
    else
      @user_email = nil
    end

     #campus = Record.id_to_campus(external_id)
     campus = @user.institution.campus
     
     if (!campus) then
       return false
     end
     
     merritt_endpoint = MERRITT_CONFIG["merritt_#{campus}_endpoint"]
     merritt_username = MERRITT_CONFIG["merritt_#{campus}_username"]
     merritt_password = MERRITT_CONFIG["merritt_#{campus}_password"]
     merritt_profile = MERRITT_CONFIG["merritt_#{campus}_profile"]

    if @user_email.nil?
      sys_output = "curl --insecure --verbose -u #{merritt_username}:#{merritt_password} -F \"file=@./#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/#{self.local_id}.zip\" -F \"type=container\" -F \"submitter=Dash/#{external_id}\" -F \"responseForm=xml\" -F \"profile=#{merritt_profile}\" -F \"localIdentifier=#{self.local_id}\" #{merritt_endpoint} 2>&1"  
    else     
      sys_output = "curl --insecure --verbose -u #{merritt_username}:#{merritt_password} -F \"file=@./#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/#{self.local_id}.zip\" -F \"notification=#{@user_email}\" -F \"type=container\" -F \"submitter=Dash/#{external_id}\" -F \"responseForm=xml\" -F \"profile=#{merritt_profile}\" -F \"localIdentifier=#{self.local_id}\" #{merritt_endpoint} 2>&1"
    end

     return sys_output  

   end
   

  


   def required_fields
    
      required_fields = Array.new
    
      if self.creators.nil? || self.creators.empty?
        required_fields << "Record must specify at least one creator."
      end

      # should we allow multiple titles?  datacite does...
      # we're only allowing one title per record

      if self.title.nil? || self.title.blank?
        required_fields << "Record must have a title."
      end

      # publisher - datacite: single, mandatory
      if self.publisher.nil? || self.publisher.blank?
        required_fields << "Record must have a publisher."
      end

      # publication year - datacite: single, mandatory
      if self.publicationyear.nil?
        required_fields << "Record must have a publication year."
      end

      #contributors - datacite: multiple, optional, mandatory contributorType attribute
      # we will require contributors for datashare

      if self.contributors.nil? || self.contributors.empty?
        #required_fields << "Record must specify at least one contributor"
      end
    
      return required_fields
   end
   

   def recommended_fields
   
      # recommended_fields = Array.new
      recommended_fields = ""
      fields = ""

      # initial_sentence = "Missing recommended field(s): "
      initial_sentence = "Consider adding these recommended field(s): "
            
      if self.subjects.nil? || self.subjects.empty?
        fields << "keywords"
      end
      
      if self.abstract == "" || self.abstract.nil?
        fields << ", " unless fields.empty?
        fields << "abstract"
      end

      if self.methods == "" || self.methods.nil?
        fields << ", " unless fields.empty?
        fields << "methods"
      end

      if self.citations.nil? || self.citations.empty?
        fields << ", " unless fields.empty?
        fields << "citations"
      end

      unless fields.empty?
        fields << "."
        recommended_fields = initial_sentence + fields
      end  
 
      return recommended_fields
   
   end
  
  
  # temp files created for multipart uploads
  def purge_temp_files
    
    file_path = "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}"
    
    self.uploads.each do |d| 
       
        # a temporary terrible hack to avoid the file corruption problem
        # on chunked uploads     
        
        if File.exist?(file_path + "/temp_" + d.upload_file_name)
          File.delete(file_path + "/" + d.upload_file_name)
          File.rename(file_path + "/temp_" + d.upload_file_name, file_path + "/" + d.upload_file_name)
        end
     end
  end
  
  
end
