class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :abbreviation
      t.string :short_name
      t.string :long_name
      t.string :landing_page
      t.string :external_id_strip

      t.timestamps
    end
  end
end
