class AddCampusToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :campus, :string
  end
end
