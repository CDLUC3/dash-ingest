class AddRecordIdToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :record_id, :integer
  end
end
