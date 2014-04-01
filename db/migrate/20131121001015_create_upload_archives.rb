class CreateUploadArchives < ActiveRecord::Migration
  def change
    create_table :upload_archives do |t|
      t.string :upload_file_name
      t.string :upload_file_size
      t.integer :submission_log_id
      t.string :upload_content_type

      t.timestamps
    end
  end
end
