class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.text :citationName
      t.integer :record_id

      t.timestamps
    end
  end
end
