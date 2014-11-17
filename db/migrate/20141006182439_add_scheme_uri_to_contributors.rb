class AddSchemeUriToContributors < ActiveRecord::Migration
  def change
    add_column :contributors, :scheme_URI, :string
  end
end
