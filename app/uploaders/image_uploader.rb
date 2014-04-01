# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/#{model.record.local_id}"
  end

  #all are currently allowed
  #def extension_white_list
  #  %w(jpg jpeg gif png tiff tif)
  #end
  
end
