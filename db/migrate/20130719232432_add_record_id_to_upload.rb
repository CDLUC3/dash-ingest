class AddRecordIdToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :record_id, :int
  end
end
