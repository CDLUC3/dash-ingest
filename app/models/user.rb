class User < ActiveRecord::Base
  has_many :records
  attr_accessible :external_id, :epsa
end
