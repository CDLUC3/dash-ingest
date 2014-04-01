class Contributor < ActiveRecord::Base
  belongs_to :record
  attr_accessible :contributorName, :contributorType, :record_id
end
