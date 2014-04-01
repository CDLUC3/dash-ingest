class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :identifier
      t.string :identifierType
      t.string :publisher
      t.string :publicationyear
      t.string :resourcetype
      t.string :rights

      t.timestamps
    end
  end
end
