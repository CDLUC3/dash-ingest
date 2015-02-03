require 'spec_helper'

describe GeoLocationBox, :type => :model do
  it "has a valid factory"
  it "has latitude values within -90 and 90 range"
  it "has longitude values within -180 and 180 range"
  it "returns no more than two coordinate pairs in Well-Known Text format"
end
