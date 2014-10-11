class GeoLocationBox < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationBox,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  TYPE = "box"
  belongs_to :record
  
  validates :sw_lat, numericality:
    { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :sw_lng, numericality: 
    { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :ne_lat, numericality:
    { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :ne_lng, numericality: 
    { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  
  attr_accessible :sw_lat, :sw_lng, :ne_lat, :ne_lng, :record_id
end
