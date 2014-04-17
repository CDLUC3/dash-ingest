class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :external_id
      t.string :epsa

      t.timestamps
    end
  end
end
