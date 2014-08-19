# require 'test_helper'
# require "capybara/rails"

# class Records_integration_Test < ActiveSupport::TestCase
  
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
  
#   test "display all records" do  
#     visit '/records'    
            
#     # assert page.has_content?("Study1")
#     # assert page.has_content?("UCSF")
#     assert page.has_content?("My Dataset")

#   end
  
#   test 'display new record page' do
#     visit '/record'    
#     assert page.has_content?("Describe Your Dataset")
#   end
  
#   test "create new record" do
#     visit '/record'
        
#     fill_in 'title', :with => 'Title1' 
#     #select('UC Office of the President', :from => 'publisher')
#     select('Poster', :from => 'resourcetype') 
#     fill_in 'creator_name', :with => 'creator name' 
#     fill_in 'subject_name', :with => 'subject name' 
#     fill_in 'abstract', :with => 'Data from healthy and cognitively impaired elderly, enriched for cerebrovascular disease.
#       Background and Purpose: To investigate whether the Framingham Cardiovascular Risk Profile (FCRP) and carotid artery intima-media 
#       thickness (CIMT) are associated with cortical volume and thickness. Results: 152 subjects (82 men) were aged 78 (+-7) years old, 94
#       had a CDR of 0, 58 had a clinical dementia rating (CDR) of 0.5 and the mean mini-mental status examination (MMSE) was 28 +-2. FCRP
#       score was inversely associated with total gray matter (GM) volume, parietal and temporal GM volume (adjusted p<0.04). FCRP was 
#       inversely associated with parietal and total cerebral GM thickness (adjusted p<0.03). CIMT was inversely associated with thickness 
#       of parietal GM only (adjusted p=0.04). Including history of myocardial infarction or stroke and radiologic evidence of brain 
#       infarction, or apoE genotype did not alter relationships with FCRP or CIMT. Conclusions: Increased cardiovascular risk was 
#       associated with reduced GM volume and thickness in regions also affected by Alzheimer\'s disease (AD), independent of infarcts 
#       and apoE genotype. These results suggest a "double hit" toward developing dementia when someone with incipient AD also has 
#       high cardiovascular risk. Subjects: Consecutive subjects were identified from an ongoing, longitudinal, multi-institutional 
#       Aging Brain program project that recruits subjects with normal cognition to mild cognitive impairment, representing a spectrum 
#       of low to high vascular risk14. Most participants were acquired through community-based recruitment using a protocol designed 
#       to obtain a demographically diverse cohort, or through sources such as stroke clinics and support groups attended by people 
#       with high vascular risk factors. All participants gave written informed consent in accordance with the policies of each 
#       institutional review board. Inclusion criteria include age 60 or older, with cognitive function in the normal to mild cognitive 
#       impairment range (Clinical Dementia Rating [CDR] score of 0 or 0.5) 15. Persons with history of multiple vascular risk factors, 
#       coronary or carotid disease, myocardial infarction, or ischemic stroke were targeted for inclusion, although patients with very 
#       large strokes that interfered with estimation of cortical volume and thickness were excluded. Exclusion criteria included evidence 
#       of alcohol or substance abuse, head trauma with loss of consciousness lasting longer than 15 minutes, factors contraindicating MRI, 
#       and severe medical illness, neurologic or psychiatric disorders unrelated to AD or vascular dementia that could significantly affect 
#       brain structure (e.g., schizophrenia and other psychotic disorders, bipolar disorder, current major depression, post-traumatic 
#       stress disorder, obsessive-compulsive disorder, liver disease, multiple sclerosis, amyotrophic lateral sclerosis). Participant 
#       demographics by CDR are shown in Table 1. Measures of cardiovascular risk and carotid atherosclerosis: The FCRP uses empirically-derived 
#       age- and gender-adjusted weighting of categorical variables to predict the 10-year risk of coronary heart disease and is a weighted sum of: 
#       age, gender, active smoking, diabetes, systolic blood pressure (and/or use of hypertensive medications) and total cholesterol and 
#       high-density lipoprotein cholesterol levels13. Higher scores indicate ' 
#     fill_in 'methods', :with => 'Consecutive subjects participating in a prospective cohort study of aging and mild cognitive impairment 
#       enriched for vascular risk factors for atherosclerosis underwent structural MRI scans at 3T and 4T MRI at three sites. Freesurfer (v5.1) 
#       was used to obtain regional measures of neocortical volumes (mm3) and thickness (mm). Multiple linear regression was used to determine 
#       the association of FCRP and CIMT with cortical volume and thickness. MRI: acquisition: Structural T1-weighted MRI scans for participants 
#       were collected on 3T and 4T MRI systems. Forty-three participants were scanned at the University of Southern California using a 3T General 
#       Electric Signal HDx system with an 8-channel head coil. Acquired images included a T1-weighted volumetric SPGR (TR = 7 ms, TE = 2.9 ms, 
#       TI= 650 ms, 1 mm3 isotropic resolution). Fifty-four participants were scanned at the University of California, Davis research center. 
#       Nine participants were scanned using a 3T Siemens Magnetom Trio Syngo System with an 8-channel head coil. Forty-five were scanned using 
#       a 3T Siemens Magnetom TrioTim system with an 8-channel head coil. Acquired images for all 54 participants included a T1-weighted volumetric 
#       MP-RAGE (TR = 2500, TE = 2.98, TI = 1100, 1 mm3 isotropic resolution). Thirty-three participants were scanned at the San Francisco Veterans 
#       Administration Medical Center using a 4T Siemens MedSpec Syngo System with an 8-channel head coil. A T1-weighted volumetric MP-RAGE scan 
#       (TR = 2300, TE = 2.84, TI = 950, 1 mm3 isotropic ' 
#     fill_in 'citation', :with => 'e.g., Patterns of age-related water diffusion changes in human brain by concordance and discordance analysis. 
#     Zhang Y, Du AT, Hayasaka S, Jahng GH, Hlavin J, Zhan W, Weiner MW, Schuff N. Neurobiol Aging. 2010 Nov;31(11):1991-2001. 
#     doi: 10.1016/j.neurobiolaging.2008.10.009. Epub 2008 Nov 25. PMID: 19036473' 
    
#     click_button 'Save'    
    
#     assert find_field('title').value == 'Title1' 
#     assert find_field('resourcetype').value == 'Other,Poster'
    
#     assert page.has_content?('creator name')
#     assert page.has_content?('subject name')
#     assert page.has_content?('high-density lipoprotein cholesterol levels13')
#     assert page.has_content?(' (TR = 2300, TE = 2.84, TI = 950, 1 mm3 isotropic')
#     assert page.has_content?('PMID: 19036473')
    
#   end
  
#   test "update record" do
#     visit "/record"
#     fill_in 'title', :with => 'updatetitle123'     
#     click_button 'Save'    
#     assert find_field('title').value == 'updatetitle123'
#   end
  
#   test "new record" do
#     visit "/record"
#     assert page.has_content?("Title")
#   end
  
#   test "add_and_delete_creator" do
#     visit "/record"
#     fill_in "creator_name", :with => "creator1"
#     click_button "Additional Creator"
  
#     assert page.has_content?("creator1")
        
#     first(:link, 'delete').click
#     assert !page.has_content?("creator1")
#   end

#   test "add_and_delete_subject" do
#     visit "/record"
#     fill_in "subject_name", :with => "subject name 1"
    
#     click_button "Additional Keyword"
        
#     assert page.has_content?("subject name 1"), "subject name created"
        
#     first(:link, 'delete').click
#     assert !page.has_content?("subject name 1"), "subject name deleted"
#   end
  
#   # test "add_multiple_subjects_through_comma_delimited_line" do
#   #   visit "/record"
#   #   fill_in "subject_name", :with => "subject1, subject2, subject3"
#   #   click_button "Add Subject"
#   #   assert !page.has_content?("subject1, subject2, subject3")
#   #   assert page.has_content?("subject3"), "subject name deleted"
#   # end
  
#   test "add_and_delete_citation" do
#     visit "/record"
#     fill_in "citation", :with => "fill_in 'citation', :with => 'e.g., Patterns of age-related water diffusion changes in human brain by concordance and discordance analysis. 
#     Zhang Y, Du AT, Hayasaka S, Jahng GH, Hlavin J, Zhan W, Weiner MW, Schuff N. Neurobiol Aging. 2010 Nov;31(11):1991-2001. 
#     doi: 10.1016/j.neurobiolaging.2008.10.009. Epub 2008 Nov 25. PMID: 19036473'"
    
#     click_button "Additional Citation"
        
#     assert page.has_content?("Epub 2008 Nov 25. PMID: 19036473")
        
#     first(:link, 'delete').click
#     assert !page.has_content?("Epub 2008 Nov 25. PMID: 19036473")
#   end
  
#   # test "require record ownership for edit" do
#   #     id = records(:two).id
#   #     visit "/record/#{id}"
            
#   #     #no ownership, redirected to index page
#   #     assert page.has_content?("My Datasets")
#   # end
  
#   test "create_review_page" do
    
#     id = records(:one).id
#     visit "/record/#{id}/review"
#     assert page.has_content?("Review Before Submitting")
#   end
  
#   # this won't really do it, the config for test
#   # is set with dummy data, no need to clutter up
#   # merritt like this
#   # so this will give the error message, not success
#   # message
#   test "send_archive_to_merritt" do
    
#     id = records(:one).id
    
#     prev_upload_count = Upload.find_all_by_record_id(id).size()
    
#     visit "/record/#{id}/send_archive_to_merritt"
#     assert page.has_content?("Submission Logs")
    
#     #in test, this step will always fail.  You'd need to have test configured
#     #to successfully submit to merritt for this test to work
#     #assert_not_equal prev_upload_count, Upload.find_all_by_record_id(id).size()
    
#   end
  
#   test "view submission logs" do
#     id = records(:one).id
#     visit "/record/#{id}/logs"
#     assert page.has_content?("Failed")
#   end
  
#   test "delete record" do
#     visit "/records"
#     assert page.has_content?("Study1")
#     first(:link, 'Delete').click
#     assert !page.has_content?("Study1")
#   end
  
  
# end
