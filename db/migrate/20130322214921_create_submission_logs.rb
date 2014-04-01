class CreateSubmissionLogs < ActiveRecord::Migration
  def change
    create_table :submission_logs do |t|
      t.text :archiveresponse

      t.timestamps
    end
  end
end
