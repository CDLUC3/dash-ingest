# require 'test_helper'
# require "capybara/rails"

# class Uploads_integration_Test < ActiveSupport::TestCase
  
#   include Capybara::DSL
  
#   setup do
#     FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
#     Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}")
#     Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890")
#     FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/1234567890/datacite.xml")
    
#     Capybara.current_session.driver.header 'eppn', 'abc123'
    
#     visit '/login'
#   end
  
#   teardown do
#     FileUtils.rm_rf(Dir.glob("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}"))
#   end

#   test "navigate to upload page" do
#     visit "/record"
#     assert page.has_content?('My Datasets')
#   end
  
#   # visit the page and validate text
#   # file upload functionality is covered in the upload functional test
#   test "file upload page" do
#     id = records(:one).id
#     visit "/record/#{id}/uploads"
#     assert page.has_content?("My Datasets")  
#   end
  
#   # visit upload page for no record
#   test "no record redirects to my datasets page" do
#      visit "/record/100/uploads"
#     assert page.has_content?("My Datasets")
#   end
  
#   # visit record not owned by current user
#   test "no ownership of record redirects to my datasets page" do
#     id = records(:two).id
#     visit "/record/#{id}/uploads"
#     assert page.has_content?("My Datasets")
#   end
  
#   # attempt to destroy non existent record
#   test "require ownership of related record to destroy upload" do
#     id = records(:two).id
#     upload_id = uploads(:two).id
#     visit "/record/#{id}/datauploads/#{upload_id}/delete"
#     assert page.has_content?("My Datasets")
#   end
  
#   test "delete upload" do  
#     id = records(:three).id
#     visit "/record/#{id}/uploads"
  
#     Dir.mkdir("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/234567891")
#     FileUtils.touch("#{Rails.root}/#{DATASHARE_CONFIG['uploads_dir']}/234567891/datacite.xml")
    
#     assert page.has_content?("datacite.xml")
#     first(:link, 'delete').click
#     assert !page.has_content?("datacite.xml")
#   end  
  
  
#   test "purge files" do
#     visit "/records"
#     prev_count = Upload.all.count
#   end

  
# end