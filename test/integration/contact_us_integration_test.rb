require 'test_helper'
require "capybara/rails"

class Contact_Us_integration_Test < ActiveSupport::TestCase
  
  include Capybara::DSL
  
  setup do
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}")
    Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890")
    FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890/datacite.xml")
    
    Capybara.current_session.driver.header 'eppn', 'abc123'
    
    visit '/login'
  end
  
  teardown do
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
  end
  
  test "send message with success" do  
    visit '/contact'    
            
    assert page.has_content?("Contact Us")
    
  end

end