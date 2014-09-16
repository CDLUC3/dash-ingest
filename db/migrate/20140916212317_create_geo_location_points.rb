class CreateGeoLocationPoints < ActiveRecord::Migration
  def change
    create_table :geo_location_points, :options => 'ENGINE=MyISAM' do |t|
      t.point :point

      t.timestamps
    end
  end
end
