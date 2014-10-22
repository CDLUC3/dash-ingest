class CreateGeoLocationBoxes < ActiveRecord::Migration
  def change
    create_table :geo_location_boxes, :options => 'ENGINE=MyISAM' do |t|
      t.decimal :sw_lat, :precision => 9, :scale => 6
      t.decimal :sw_lng, :precision => 9, :scale => 6
      t.decimal :ne_lat, :precision => 9, :scale => 6
      t.decimal :ne_lng, :precision => 9, :scale => 6
      t.integer :record_id

      t.timestamps
    end
  end
end
