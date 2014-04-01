class CreateAlternateIdentifiers < ActiveRecord::Migration
  def change
    create_table :alternate_identifiers do |t|
      t.string :alternateIdentifierName
      t.string :alternateIdentifierType
      t.integer :record_id

      t.timestamps
    end
  end
end
