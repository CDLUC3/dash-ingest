class Creator < ActiveRecord::Base
  attr_accessible :creatorName, :record_id
  validates :creatorName, :presence => true
  #validates_associated :record
  belongs_to :record, :inverse_of => :creators



end
