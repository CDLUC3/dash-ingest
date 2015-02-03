class CreateGeoLocationPoints < ActiveRecord::Migration
  def change
    create_table :geo_location_points, :options => 'ENGINE=MyISAM' do |t|
      t.decimal :lat, :precision => 9, :scale => 6
      t.decimal :lng, :precision => 9, :scale => 6
      t.integer :record_id

      t.timestamps
    end
  end
end
