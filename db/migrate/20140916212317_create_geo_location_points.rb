class CreateGeoLocationPoints < ActiveRecord::Migration
  def change
    create_table :geo_location_points, :options => 'ENGINE=MyISAM' do |t|
      t.float :lat
      t.float :lng
      t.integer :record_id

      t.timestamps
    end
  end
end
