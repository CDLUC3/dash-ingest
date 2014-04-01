class ChangeAbstractToText < ActiveRecord::Migration
  def up
    change_column :records, :abstract, :text, :limit => nil
  end

  def down
  end
end
