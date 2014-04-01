class AddCitationToRecord < ActiveRecord::Migration
  def change
    add_column :records, :citation, :string
  end
end
