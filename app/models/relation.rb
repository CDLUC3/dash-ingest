class Relation < ActiveRecord::Base
  belongs_to :record
  attr_accessible :relationText
end
