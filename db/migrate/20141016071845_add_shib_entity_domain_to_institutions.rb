class AddShibEntityDomainToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :shib_entity_domain, :string
  end
end
