class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
      t.string :creatorName

      t.timestamps
    end
  end
end
