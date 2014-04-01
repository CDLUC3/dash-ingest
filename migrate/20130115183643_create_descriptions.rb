class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.string :descriptionType
      t.text :descriptionText
      t.integer :record_id

      t.timestamps
    end
  end
end
