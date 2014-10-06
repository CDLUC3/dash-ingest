class ChangeRelatedIdTypeForCitations < ActiveRecord::Migration
  def change
    # change_column :citations, :related_id_type, :enum, limit: [:ark, :doi, :ean13, :eissn, :handle, :isbn, :issn, :istc, :lissn, :lsid, :pmid, :purl, :upc, :url, :urn]
  	change_column :citations, :related_id_type, :integer
  end
end
