class Subject < ActiveRecord::Base
  belongs_to :record
  attr_accessible :subjectName, :subjectScheme
end
