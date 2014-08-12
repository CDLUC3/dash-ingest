class User < ActiveRecord::Base
  has_many :records
  attr_accessible :external_id, :epsa, :email



   def self.institution_from_shibboleth(id)
      if ( id == nil )
        return Institution.find_by_id(1)
      end
     # external ID form: john.doe@someplace.edu
     #case id.strip

      Institution.all.each do |i|
        if Regexp.new(i.external_id_strip).match(id)
          return i
        end

      end
     

     # when /.*@.*ucop.edu$/
     #   result = "/.*@.*ucop.edu$/"
     # when /.*@.*uci.edu$/
     #   result = "/.*@.*uci.edu$/"
     # when /.*@.*ucla.edu$/
     #   result = "/.*@.*ucla.edu$/"
     # when /.*@.*ucsd.edu$/
     #   result = "/.*@.*ucsd.edu$/"
     # when /.*@.*ucsb.edu$/
     #   result = "/.*@.*ucsb.edu$/"
     # when /.*@.*berkeley.edu$/
     #   result = "/.*@.*berkeley.edu$/"
     # when /.*@.*ucdavis.edu$/
     #   result = "/.*@.*ucdavis.edu$/"
     # when /.*@.*ucmerced.edu$/
     #   result = "/.*@.*ucmerced.edu$/"
     # when /.*@.*ucr.edu$/
     #   result = "/.*@.*ucr.edu$/"
     # when /.*@.*ucsf.edu$/
     #   result = "/.*@.*ucsf.edu$/"
     # when /.*@.*ucsc.edu$/
     #   result = "/.*@.*ucsc.edu$/"
     # else 
     #   result = "/.*@.*ucop.edu$/"
     # end
     # result
   end


end
