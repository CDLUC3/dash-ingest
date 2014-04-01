class CreateDatauploads < ActiveRecord::Migration
  def change
    create_table :datauploads do |t|
      t.string :name
      t.string :image
      t.integer :record_id

      t.timestamps
    end
  end
end
