class RemoveCitationFromRecord < ActiveRecord::Migration
  def up
    remove_column :records, :citation
  end

  def down
    add_column :records, :citation, :string
  end
end
