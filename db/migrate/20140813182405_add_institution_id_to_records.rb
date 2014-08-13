class AddInstitutionIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :institution_id, :integer
    add_index :records, :institution_id
  end
end
