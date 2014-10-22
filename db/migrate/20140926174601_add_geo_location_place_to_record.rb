class AddGeoLocationPlaceToRecord < ActiveRecord::Migration
  def change
    add_column :records, :geoLocationPlace, :string
  end
end
