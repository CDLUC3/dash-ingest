class Creator < ActiveRecord::Base
  
  belongs_to :record, :inverse_of => :creators

  attr_accessible :creatorName, :record_id
  
  validates_presence_of :creatorName, :message => "^You must add at least one creator."

end
