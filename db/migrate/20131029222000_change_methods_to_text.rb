class ChangeMethodsToText < ActiveRecord::Migration
  def up
     change_column :records, :methods, :text, :limit => nil
  end

  def down
  end
end
