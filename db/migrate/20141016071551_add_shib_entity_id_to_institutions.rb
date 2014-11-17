class AddShibEntityIdToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :shib_entity_id, :string
  end
end
