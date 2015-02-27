class GeoLocationPoint < ActiveRecord::Base
  # Use the WSG84 spherical geographic coordinate system (SRID 4326)
  #set_rgeo_factory_for_column(:geoLocationPoint,
  #  RGeo::Geographic.spherical_factory(:srid => 4326))
  TYPE = "point"
  belongs_to :record, :inverse_of => :geoLocationPoints
  
#  validate :points_count_within_limit, :on => :create
  validates :lat, numericality:
    { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lng, numericality: 
    { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  
  attr_accessible :lat, :lng, :record_id
  
#  private
  
#    def points_count_within_limit
#      return unless self.record
#      self.errors.add (:geoLocationPoint, "a maximum of 25 points allowed") if self.record.geoLocationPoints.size < 25
#    end
end
