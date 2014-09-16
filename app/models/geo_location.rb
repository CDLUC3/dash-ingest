class GeoLocation < ActiveRecord::Base
  belongs_to :geospatial, polymorphic: true
  belongs_to :record
  
  attr_accessible :geoLocationPlace, :record_id
end
