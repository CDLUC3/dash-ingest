class AddRightsUriToRecords < ActiveRecord::Migration
  def change
    add_column :records, :rights_uri, :string
  end
end
