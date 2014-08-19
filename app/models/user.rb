class User < ActiveRecord::Base
  
  has_many :records
  belongs_to :institution
  
  attr_accessible :external_id, :epsa, :email



	def self.institution_from_shibboleth(id)
	  if ( id == nil )
	    return Institution.find_by_id(1)
	  end
	  Institution.all.each do |i|
	    if Regexp.new(i.external_id_strip).match(id)
	      return i
	    end
	  end
	end


end
