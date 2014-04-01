class UploadArchive < ActiveRecord::Base
  belongs_to :submissionLog
  
  attr_accessible :submission_log_id, :upload_file_size, :upload_file_name, :upload_content_type
end
