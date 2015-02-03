# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :geoLocationPoint do |f|
    f.lat "33.6409"
    f.lng "-117.77"
  end
end
