class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :subjectName
      t.string :subjectScheme

      t.timestamps
    end
  end
end
