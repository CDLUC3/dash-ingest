DataIngest::Application.routes.draw do



  resources :uploads
  root :to => 'login#login'

  resources :records

  match 'record/:record_id/uploads', :to => "uploads#index"
  match 'record/:record_id/uploads/new', :to => "uploads#new"
  
  match 'update_dataupload/:id', :to => "datauploads#update_dataupload"
  
  match 'record/:id/datauploads/:dataupload_id/delete', :to => "datauploads#destroy"
  
  match 'records', :to => "records#index"
  match 'record/:id', :to => "records#edit"
  match 'record/', :to => "records#new"
  #match 'record/show', :to => "records#show"
  
  match 'record/:id/review', :to => "records#review"
  match 'record/:id/delete', :to => "records#delete"
  
  match 'record/:id/send_archive_to_merritt', :to => "records#send_archive_to_merritt"
  
  match 'record/:id/logs', :to => "records#submission_log"
  
  match 'update_record(/:id)', :to => "records#update_record", :via => :post

  match 'contact', to: 'static_pages#contact', :via => [:get, :post], as: 'contact'

  match 'delete_creator/:id/:creator_id', :to => "records#delete_creator"
  match 'delete_contributor/:id/:contributor_id', :to => "records#delete_contributor"
  match 'delete_description/:id/:description_id', :to => "records#delete_description"
  match 'delete_subject/:id/:subject_id', :to => "records#delete_subject"
  match 'delete_relation/:id/:relation_id', :to => "records#delete_relation"
  match 'delete_alternateIdentifier/:id/:alternateIdentifier_id', :to => "records#delete_alternateIdentifier"
  
  match 'login', :to => "login#login"
  match 'login_page', :to => "login#login_page"
  match 'logout_page', :to => "login#logout_page"
  
  match 'logout', :to => "login#logout"
  
  match 'export', :to => "records#parse_feed"
  
  match 'terms_of_use', :to => "records#terms_of_use"
  match 'prepare_to_submit', :to => "records#prepare_to_submit"  
  match 'metadata_basics', :to => "records#metadata_basics"  
  match 'steps_to_publish', :to => "records#steps_to_publish"  
  match 'upload_faq', :to => "records#upload_faq_page"  
  match 'data_use_agreement', :to => "records#data_use_agreement"  

end