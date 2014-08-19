class AddInstitutionIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :institution_id, :integer
    add_index :users, :institution_id
  end
end
