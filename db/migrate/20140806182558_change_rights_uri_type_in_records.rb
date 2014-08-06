class ChangeRightsUriTypeInRecords < ActiveRecord::Migration
  def up
  	change_column :records, :rights_uri, :text
  end

  def down
  	change_column :records, :rights_uri, :string
  end
end
