class Creator < ActiveRecord::Base
  belongs_to :record
  attr_accessible :creatorName
end
