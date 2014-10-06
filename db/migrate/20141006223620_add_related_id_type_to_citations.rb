class AddRelatedIdTypeToCitations < ActiveRecord::Migration
  def change
    add_column :citations, :related_id_type, :string
  end
end
