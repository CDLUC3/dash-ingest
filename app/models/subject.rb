class Subject < ActiveRecord::Base


  belongs_to :record, :inverse_of => :subjects
  attr_accessible :subjectName, :record_id
  #validate :subjectName , :allow_nil => false
end
