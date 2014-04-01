class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :contributorType
      t.string :contributorName
      t.integer :record_id

      t.timestamps
    end
  end
end
