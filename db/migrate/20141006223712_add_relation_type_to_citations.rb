class AddRelationTypeToCitations < ActiveRecord::Migration
  def change
    add_column :citations, :relation_type, :string
  end
end
