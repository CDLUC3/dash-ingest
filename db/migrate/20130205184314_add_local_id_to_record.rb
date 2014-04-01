class AddLocalIdToRecord < ActiveRecord::Migration
  def change
    add_column :records, :local_id, :string
  end
end
