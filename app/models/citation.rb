class Citation < ActiveRecord::Base

  attr_accessible :citationName, :record_id, :related_id_type, :relation_type
  
  belongs_to :record, :inverse_of => :citations

  # validates_presence_of :citationName
  
end
