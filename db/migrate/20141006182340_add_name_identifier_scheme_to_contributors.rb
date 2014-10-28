class AddNameIdentifierSchemeToContributors < ActiveRecord::Migration
  def change
    add_column :contributors, :name_identifier_scheme, :string
  end
end
