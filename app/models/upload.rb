class Upload < ActiveRecord::Base
  belongs_to :record
  before_create :default_name
  
  attr_accessible :upload, :upload_file_size, :upload_content_type, :upload_file_name, :record_id
  has_attached_file :upload, :path => :set_default_url_on_record_id
  do_not_validate_attachment_file_type :upload

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end

  def set_default_url_on_record_id
      record = Record.find_by_id(self.record_id)
      ":rails_root/#{DATASHARE_CONFIG['uploads_dir']}/#{record.local_id}/#{self.upload_file_name}"
  end

  def default_name

     # allow duplicate names, but append a timestamp to the names
     # otherwise, the zip utility will throw an error on duplicate names
     if self.record.uploads.pluck(:upload_file_name).include?(self.upload_file_name)
       self.upload_file_name = self.upload_file_name + "_" + Time.now.utc.iso8601.gsub('-', '').gsub(':', '')
     end
   end
   
   # delete all files more than a week old? (?)
   # not currently used
   def self.purge_old_files
      puts "purging files"
      uploads = Upload.where('created_at < ?', 1.week.ago)
      
      # delete each uploads corresponding file, then delete the upload metadata from the db
      uploads.each do |u| 
        file_path = "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{u.record.local_id}"
        if File.exists?("#{file_path}")
           FileUtils.rm_rf Dir.glob("#{file_path}/*")
        end
        u.delete
      end
      
      redirect_to "/records"
      
   end

end
