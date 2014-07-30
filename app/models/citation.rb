class Citation < ActiveRecord::Base
  attr_accessible :citationName, :record_id
  #validates_associated :record
  belongs_to :record, :inverse_of => :citations
end
