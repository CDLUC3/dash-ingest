module ApplicationHelper

	def url_to_campus 
  	id = request.headers[DATASHARE_CONFIG['external_identifier']]
   	if ( id == nil )
     	@campus = "cdl"
    else
	     case id.strip
	     when /.*@.*ucop.edu$/
	       @campus = "cdl"
	     when /.*@.*uci.edu$/
	       @campus = "uci"
	     when /.*@.*ucla.edu$/
	       @campus = "ucla"
	     when /.*@.*ucsd.edu$/
	       @campus = "ucsd"
	     when /.*@.*ucsb.edu$/
	       @campus = "ucsb"
	     when /.*@.*berkeley.edu$/
	       @campus = "ucb"
	     when /.*@.*ucdavis.edu$/
	       @campus = "ucd"
	     when /.*@.*ucmerced.edu$/
	       @campus = "ucm"
	     when /.*@.*ucr.edu$/
	       @campus = "ucr"
	     when /.*@.*ucsf.edu$/
	       @campus = "ucsf"
	     when /.*@.*ucsc.edu$/
	       @campus = "ucsc"
	     else	
	       @campus = "cdl"
	     end
	  end
   	@campus
 	end

 	
end
