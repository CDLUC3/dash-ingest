class CreateGeoLocations < ActiveRecord::Migration
  def change
    create_table :geo_locations do |t|
      t.text :geoLocationPlace
      t.integer :record_id
      t.references :geospatial, polymorphic:true
      
      t.timestamps
    end
  end
end
