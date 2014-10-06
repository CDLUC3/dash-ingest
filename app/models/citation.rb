class Citation < ActiveRecord::Base

  attr_accessible :citationName, :record_id
  
  belongs_to :record, :inverse_of => :citations

  

  # as_enum :related_id_type, :ark => 0, 
  # 													:doi => 1, 
  # 													:ean13 => 2, 
  # 													:eissn => 3, 
  # 													:handle => 4, 
  # 													:isbn => 5, 
  # 													:issn => 6, 
  # 													:istc => 7, 
  # 													:lissn => 8, 
  # 													:lsid => 9, 
  # 													:pmid => 10, 
  # 													:purl => 11, 
  # 													:upc => 12, 
  # 													:url => 13, 
  # 													:urn => 14


  as_enum :related_id_type, [:ARK, :DOI, :EAN13, :EISSN, :HANDLE, :ISBN, :ISSN, :ISTC, :LISSN, :LSID, :PMID, :PURL, :UPC, :URL, :URN]
  as_enum :relation_type, [:IsCitedBy, :Cites, :IsSupplementTo, :IsSupplementedBy, :IsContinuedBy, :Continues, :HasMetadata, :IsMetadataFor, :IsNewVersionOf, :IsPreviousVersionOf, :IsPartOf, :HasPart, :IsReferencedBy, :References, :IsDocumentedBy, :Documents, :IsCompiledBy, :Compiles, :IsVariantFormOf, :IsOriginalFormOf, :IsIdenticalTo]

end
