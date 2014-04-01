class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :relationText

      t.timestamps
    end
  end
end
