class SubmissionLog < ActiveRecord::Base
  belongs_to :record
  has_many :uploadArchives
  
  attr_accessible :archiveresponse
  
  def filtered_response
    
    if !self.archiveresponse.nil?

      if self.archiveresponse.include?("QUEUED") || self.archiveresponse.include?("PENDING")
        return "Success: Record Uploaded to Datashare"
      elsif self.archiveresponse.include?("PROCESSING")
        return "Sending To Merritt (Processing)"
      else
        return "Failed"# + self.archiveresponse
      end
    end
    
  end
  
end
