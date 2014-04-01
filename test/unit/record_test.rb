require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  
  setup do
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}")
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890")
    FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890/datacite.xml")
  end
  
  test "can build and populate the record model" do
    record = Record.new
    record.identifier = 'abc'
    record.identifierType = 'ROI'
    record.publisher = 'Cambridge Press'
    record.publicationyear = '1997'
    record.resourcetype = 'data'
    record.rights = 'copyright ucsf'
    record.local_id = "1234567890"
    
    assert_equal record.identifier, 'abc'
  end
  
  test "creates valid datacite xml" do
    record = records(:one)
    xmlout = record.review
  end
  
  test "required and recommended fields" do
    record = Record.new
    
    assert_equal record.required_fields[0], "Record must specify at least one creator"
    assert_equal record.required_fields[1], "Record must have a title"
    assert_equal record.required_fields[2], "Record must have a publisher"
    assert_equal record.required_fields[3], "Record must have a publication year"
    assert_equal record.required_fields[4], "Record must specify at least one contributor"

    assert_equal record.recommended_fields[0], "Subject data is strongly recommended.  Your record may be ommitted from search and browse results withough a subject"
    #assert_equal record.recommended_fields[1], "While not required, an abstract and technical description are strongly recommended."
  
  end
  
  test "purges files" do
    record = Record.new
    record.save
    
    upload = Upload.new
    upload.record_id = record.id
    upload.save
    
    assert_equal record.uploads.count, 1
    
    #record.purge_files
  end
  
end
