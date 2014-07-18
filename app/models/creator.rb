class Creator < ActiveRecord::Base
  belongs_to :record
  attr_accessible :creatorName
  validates_presence_of :creatorName

end
