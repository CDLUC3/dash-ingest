class AddDataOneToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :data_one, :string
  end
end
