class GeoLocationPoint < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationPoint,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  TYPE = "point"
  belongs_to :record, :inverse_of => :geoLocationPoints
  
  validates :lat, numericality: 
    { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lng, numericality: 
    { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  
  attr_accessible :lat, :lng, :record_id
end
