class Description < ActiveRecord::Base
  belongs_to :record
  attr_accessible :descriptionText, :descriptionType, :record_id
end
