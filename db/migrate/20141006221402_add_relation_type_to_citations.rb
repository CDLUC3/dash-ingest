class AddRelationTypeToCitations < ActiveRecord::Migration
  def change
    add_column :citations, :relation_type, :integer
  end
end
