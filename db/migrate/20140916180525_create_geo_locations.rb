class CreateGeoLocations < ActiveRecord::Migration
  def change
    create_table :geo_locations do |t|
      t.text :geoLocationPlace
      t.references :geospatial, polymorphic: true
      t.references :record, index: true
      
      t.timestamps
    end
  end
end
