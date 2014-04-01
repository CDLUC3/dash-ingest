require 'test_helper'

class UploadsControllerTest < ActionController::TestCase
  setup do
    @request.session["user_id"] = 1
    
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}")
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890")
    FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890/datacite.xml")
  end
  
  test "create and purge file upload" do
    test_image = "#{Rails.root}/test/fixtures/files/datacite.xml"
      file = Rack::Test::UploadedFile.new(test_image)
      post "create", :record_id => 1, :upload => {:upload => file}
      
      assert_equal Record.find(1).uploads.count, 1
      Record.find(1).purge_files(1)
      assert_equal Record.find(1).uploads.count, 0
  end
  
  test "delete file upload" do
    put "destroy", :id => uploads(:one).id
  end  
    
  
end
