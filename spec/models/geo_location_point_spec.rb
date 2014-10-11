require 'spec_helper'

describe GeoLocationPoint do
  it "has a valid factory" do
    expect(FactoryGirl.create(:geoLocationPoint)).to be_valid
  end
  it "has a latitude value within -90 and 90 range"
  it "has a longitude value within -180 and 180 range"
  it "returns a lat-long coordinate pair in Well-Known Text format"
  it "is associated with a Record"
  it "is invalid if there are already 25 points associated with a Record"
  it "is invalid if there is a geospatialType of 'box'"
  it "is invalid if there is a geospatialType of 'none'"
  it "is invalid if geospatialType is blank/nil"
end
