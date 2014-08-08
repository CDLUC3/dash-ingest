class ChangeRightsTypeInRecords < ActiveRecord::Migration
  def up
  	change_column :records, :rights, :text
  end

  def down
  	change_column :records, :rights, :string
  end
end
