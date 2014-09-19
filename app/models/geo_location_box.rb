class GeoLocationBox < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationBox,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  has_many :geoLocations, as: :geospatial
  
  attr_accessible :box
end
