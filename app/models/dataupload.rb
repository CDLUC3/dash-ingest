class Dataupload < ActiveRecord::Base
  
  attr_accessible :image, :name, :record_id
  mount_uploader :image, ImageUploader

  before_create :default_name
  belongs_to :record
  
  def default_name
   
    # if this is coming through the js version, we will need the name from the image.filename 
    if !image.filename.nil?
      self.name ||= image.filename
    end

  end
end

