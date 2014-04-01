class AlternateIdentifier < ActiveRecord::Base
  belongs_to :record
  attr_accessible :alternateIdentifierName, :record_id, :AlternateIdentifierType
end
