class AddAbstractToRecord < ActiveRecord::Migration
  def change
    add_column :records, :abstract, :string
  end
end
