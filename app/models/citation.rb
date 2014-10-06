class Citation < ActiveRecord::Base

  attr_accessible :citationName, :record_id, :related_id_type
  
  belongs_to :record, :inverse_of => :citations


  
end
