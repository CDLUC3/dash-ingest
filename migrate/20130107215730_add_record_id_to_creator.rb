class AddRecordIdToCreator < ActiveRecord::Migration
  def change
    add_column :creators, :record_id, :integer
  end
end
