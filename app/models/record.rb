require 'rubygems'
require 'zip/zip'

class Record < ActiveRecord::Base
  include RecordHelper

  has_many :creators, :dependent => :destroy
  has_many :contributors, :dependent => :destroy
  has_many :descriptions, :dependent => :destroy
  has_many :subjects, :dependent => :destroy
  has_many :alternateIdentifiers
  has_many :datauploads
  has_many :relations
  has_many :submissionLogs
  has_many :uploads,   :dependent => :destroy
  has_many :citations, :dependent => :destroy

  attr_accessor :funder
  attr_accessor :grant_number
  attr_accessor :suborg

  belongs_to :user
  belongs_to :institution

  attr_accessible :identifier, :identifierType, :publicationyear, :publisher,
                  :resourcetype, :rights, :rights_uri, :title, :local_id,:abstract,
                  :methods, :funder, :grant_number, :suborg


  validate :must_have_creators
  validate :links_not_empty_if_present

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

  accepts_nested_attributes_for :descriptions, allow_destroy: true, reject_if: proc { |attributes| attributes.all? { |key, value| key == '_destroy' || value.blank? } }
  attr_accessible :descriptions_attributes



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


  def links_not_empty_if_present
    valid = 1
    citations.each do |citation|
      if ( (citation.citationName.blank? || citation.citationName.nil?) && (citation.related_id_type.nil? || citation.related_id_type.blank?) && (citation.relation_type.nil? || citation.relation_type.blank?) )
        valid = 1
      elsif ( (citation.citationName.blank? || citation.citationName.nil?) || (citation.related_id_type.blank?) || (citation.relation_type.blank?) )
        valid = 0
        errors.add(:base, 'Link name cannot be empty.') if (citation.citationName.blank? || citation.citationName.nil?)
        errors.add(:base, 'Link type cannot be empty.') if ( citation.related_id_type.nil? || citation.related_id_type.blank?)
        errors.add(:base, 'Relationship cannot be empty.') if ( citation.relation_type.nil? || citation.relation_type.blank?)
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


  def data_manager
    @data_manager = self.contributors.where(contributorType: 'DataManager').find(:first)
    @data_manager[:contributorName] if @data_manager
  end


  def grant_number
    @grant_number = self.descriptions.where(descriptionType: 'Other').find(:first)
    @grant_number[:descriptionText] if @grant_number
  end


  def review
    @total_size = self.total_size
    @funder_name = self.funder
    @data_manager_name = self.data_manager
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
        xml.publisher "#{self.publisher}"
        xml.publicationYear "#{self.publicationyear}"
        xml.subjects {
          self.subjects.each do |s|
            xml.subject "#{s.subjectName.gsub(/\r/,"")}"
          end
        }

        unless @data_manager_name.blank? && @funder_name.blank?
          xml.contributors {
            unless @data_manager_name.blank?
              xml.contributor("contributorType" => "DataManager") {
                xml.contributorName @data_manager_name
              }
            end
            unless @funder_name.blank?
              xml.contributor("contributorType" => "Funder") {
                xml.contributorName @funder_name
              }
            end
          }
        end

        xml.relatedIdentifiers {
          self.citations.each do |c|
            xml.relatedIdentifier("relatedIdentifierType" => "#{c.related_id_type}",
                                  "relationType" => "#{c.relation_type}") {
              xml.text("#{c.citationName.gsub(/\r/,"")}")
            }
          end
        }

        xml.resourceType("resourceTypeGeneral" => "#{resourceTypeGeneral(self.resourcetype)}") {
          xml.text("#{resourceTypeGeneral(self.resourcetype)}")
        }
        xml.sizes {
          xml.size @total_size
        }
        xml.rightsList {
          xml.rights("rightsURI" => "#{self.rights_uri}") {
            xml.text("#{self.rights}")
          }
        }
        xml.descriptions{
          unless self.abstract.nil?
            xml.description("descriptionType" => "Abstract") {
              xml.text("#{self.abstract.gsub(/\r/,"")}")
            }
          end
          unless self.methods.nil?
            xml.description("descriptionType" => "Methods") {
              xml.text("#{self.methods.gsub(/\r/,"")}")
            }
          end
          self.descriptions.each do |d|
            xml.description("descriptionType" => "Other") {
              xml.text("#{d.descriptionText.gsub(/\r/,"")}")
            }
          end
        }
      }
    end
    f = File.open("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/datacite.xml", 'w') { |f| f.print(builder.to_xml) }
    puts builder.to_xml.to_s
    builder.to_xml.to_s
  end


  def dataone
    File.new("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/dataone.txt", "w:ASCII-8BIT")

    @files = self.uploads_list

    content =   "%dataonem_0.1 " + "\n" +
        "%profile | http://uc3.cdlib.org/registry/ingest/manifest/mrt-dataone-manifest " + "\n" +
        "%prefix | dom: | http://uc3.cdlib.org/ontology/dataonem " + "\n" +
        "%prefix | mrt: | http://uc3.cdlib.org/ontology/mom " + "\n" +
        "%fields | dom:scienceMetadataFile | dom:scienceMetadataFormat | " +
        "dom:scienceDataFile | mrt:mimeType " + "\n"

    @files.each do |file|

      if file

        content <<    "mrt-datacite.xml | http://schema.datacite.org/meta/kernel-3/metadata.xsd | " +
            "#{file[:name]}" + " | #{file[:type]} " + "\n" + "mrt-dc.txt | " +
            "http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd | " +
            "#{file[:name]}" + " | #{file[:type]} " + "\n"
      end
    end

    content << "%eof "

    File.open("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/dataone.txt", 'w') do |f|
      f.write(content)
    end
    puts content.to_s
    content.to_s
  end


  def uploads_list
    files = []
    current_uploads = Upload.find_all_by_record_id(self.id)
    current_uploads.each do |u|
      hash = {:name => u.upload_file_name, :type => u.upload_content_type}
      files.push(hash)
    end
    if ( !self.submissionLogs.empty? && !self.submissionLogs.nil?)
      self.submissionLogs.each do |log|
        if log.filtered_response.include?("Success")
          if ( log.uploadArchives && !log.uploadArchives.empty?)
            log.uploadArchives.each do |arch|    
              current_uploads.each do |u|
                unless u[:upload_file_name].include?(arch.upload_file_name)
                  hash = {:name => arch.upload_file_name, :type => arch.upload_content_type}
                  files.push(hash)
                end
              end
              
            end
          end
        end
      end
    end
    files
  end


  # def file_already_submitted
  #   current_uploads = Upload.find_all_by_record_id(self.id)
    
  #   current_uploads.each do |u|
  #     unless u[:upload_file_name].include?(arch.upload_file_name)
  #       files.push(hash)
  #     end
  #   end
  #   # for i in 0..(size - 1)
  #   #   if current_uploads[i][:upload_file_name].include?(arch.upload_file_name)
  #   #     return true
  #   #   end
  #   # end
  #   return false
  # end


  def dublincore
    @total_size = self.total_size
    @funder_name = self.funder
    @data_manager = self.data_manager
    xml_content = File.new("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{self.local_id}/dublincore.xml", "w:ASCII-8BIT")

    #dc_builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
    dc_builder = Nokogiri::XML::Builder.new do |xml|
      xml.qualifieddc('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'xsi:noNamespaceSchemaLocation' => 'http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd',
                      'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
                      'xmlns:dcterms' => 'http://purl.org/dc/terms/') {

        self.creators.each do |c|
          xml.send(:'dc:creator', "#{c.creatorName.gsub(/\r/,"")}")
        end
        xml.send(:'dc:title', "#{self.title}")
        xml.send(:'dc:publisher', "#{self.publisher}")
        xml.send(:'dc:date', "#{self.publicationyear}")
        self.subjects.each do |s|
          xml.send(:'dc:subject', "#{s.subjectName.gsub(/\r/,"")}")
        end

        xml.send(:'dc:contributor', @funder_name) unless @funder_name.blank?

        self.citations.each do |c|

          case c.relation_type
            when "IsPartOf"
              xml.send(:'dcterms:isPartOf', "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "HasPart"
              xml.send(:'dcterms:hasPart',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsCitedBy"
              xml.send(:'dcterms:isReferencedBy',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "Cites"
              xml.send(:'dcterms:references',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsReferencedBy"
              xml.send(:'dcterms:isReferencedBy',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "References"
              xml.send(:'dcterms:references',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsNewVersionOf"
              xml.send(:'dcterms:isVersionOf',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsPreviousVersionOf"
              xml.send(:'dcterms:hasVersion',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsVariantFormOf"
              xml.send(:'dcterms:isVersionOf',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            when "IsOriginalFormOf"
              xml.send(:'dcterms:hasVersion',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
            else
              xml.send(:'dcterms:relation',  "#{c.related_id_type}" + ": " + "#{c.citationName}")
          end
        end

        xml.send(:'dc:format', "#{resourceTypeGeneral(self.resourcetype)}")
        xml.send(:'dcterms:extent', @total_size)
        xml.send(:'dc:rights', "#{self.rights}")

        xml.send(:'dcterms:license', "#{self.rights_uri}", "xsi:type" => "dcterms:URI")

        unless self.abstract.nil?
          xml.send(:'dc:description', "#{self.abstract.gsub(/\r/,"")}")
        end
        unless self.methods.nil?
          xml.send(:'dc:description', "#{self.methods.gsub(/\r/,"")}")
        end
        self.descriptions.each do |d|
          xml.send(:'dc:description', "#{d.descriptionText.gsub(/\r/,"")}")
        end
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
        #if ( !log.uploadArchives.empty? && !log.uploadArchives.empty?)
        if ( log.uploadArchives && !log.uploadArchives.empty?)
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

    File.open("#{file_path}/mrt-dataone-manifest.txt", "w") do |f|
      f.write self.dataone
    end

    

    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add("mrt-datacite.xml", "#{file_path}/mrt-datacite.xml")
      zipfile.add("mrt-dc.xml", "#{file_path}/mrt-dc.xml")
      zipfile.add("mrt-dataone-manifest.txt", "#{file_path}/mrt-dataone-manifest.txt")

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


  def related_id_types
    ['ARK', 'DOI', 'EAN13', 'EISSN', 'HANDLE', 'ISBN', 'ISSN',
     'ISTC', 'LISSN', 'LSID', 'PMID', 'PURL', 'UPC', 'URL', 'URN']
  end


  def relation_types
    [ 'IsCitedBy', 'Cites', 'IsSupplementTo', 'IsSupplementedBy',
      'IsNewVersionOf', 'IsPreviousVersionOf',
      'IsPartOf',  'IsDocumentedBy', 'Documents', 'IsIdenticalTo']
  end


  def relation_types_hash
    hash = [  ['is cited by', 'IsCitedBy'], ['cites', 'Cites'], ['is a supplement to', 'IsSupplementTo'],
              ['is supplemented by', 'IsSupplementedBy'], ['is new version of', 'IsNewVersionOf'],
              ['is previous version of', 'IsPreviousVersionOf'], ['is part of', 'IsPartOf'],
              ['is documented by', 'IsDocumentedBy'],
              ['documents', 'Documents'], ['is identical to', 'IsIdenticalTo']
    ]
  end


end


