class CreateGeoLocationBoxes < ActiveRecord::Migration
  def change
    create_table :geo_location_boxes, :options => 'ENGINE=MyISAM' do |t|
      t.float :sw_lat
      t.float :sw_lng
      t.float :ne_lat
      t.float :ne_lng
      t.integer :record_id

      t.timestamps
    end
  end
end
