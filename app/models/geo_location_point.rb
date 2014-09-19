class GeoLocationPoint < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationPoint,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  validates :point, presence: true
  has_many :geoLocations, as: :geospatial
  
  attr_accessible :point
end
