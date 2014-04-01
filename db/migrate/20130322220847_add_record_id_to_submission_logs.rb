class AddRecordIdToSubmissionLogs < ActiveRecord::Migration
  def change
    add_column :submission_logs, :record_id, :integer
  end
end
