class AddMethodsToRecord < ActiveRecord::Migration
  def change
    add_column :records, :methods, :string
  end
end
