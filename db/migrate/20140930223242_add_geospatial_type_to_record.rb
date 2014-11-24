class AddGeospatialTypeToRecord < ActiveRecord::Migration
  def change
    add_column :records, :geospatialType, :string
  end
end
