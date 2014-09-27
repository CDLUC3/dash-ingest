class GeoLocationPoint < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationPoint,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  TYPE = "point"
  belongs_to :record, :inverse_of => :geoLocationPoints
  
  attr_accessible :lat, :lng, :record_id
end
