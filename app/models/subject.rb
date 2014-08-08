class Subject < ActiveRecord::Base

  belongs_to :record, :inverse_of => :subjects, :dependent => :destroy
  attr_accessible :subjectName, :record_id
end
