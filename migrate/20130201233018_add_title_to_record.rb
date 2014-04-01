class AddTitleToRecord < ActiveRecord::Migration
  def change
    add_column :records, :title, :string
  end
end
