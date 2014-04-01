class AddRecordIdToRelation < ActiveRecord::Migration
  def change
    add_column :relations, :record_id, :integer
  end
end
