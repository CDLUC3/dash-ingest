class AddNameIdentifierToContributors < ActiveRecord::Migration
  def change
    add_column :contributors, :name_identifier, :string
  end
end
