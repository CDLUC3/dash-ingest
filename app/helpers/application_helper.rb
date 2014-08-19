module ApplicationHelper

	# def url_to_campus 
 #  	id = request.headers[DATASHARE_CONFIG['external_identifier']]
 #   	if ( id == nil )
 #     	@campus = "cdl"
 #    else
	#      case id.strip
	#      when /.*@.*ucop.edu$/
	#        @campus = "cdl"
	#      when /.*@.*uci.edu$/
	#        @campus = "uci"
	#      when /.*@.*ucla.edu$/
	#        @campus = "ucla"
	#      when /.*@.*ucsd.edu$/
	#        @campus = "ucsd"
	#      when /.*@.*ucsb.edu$/
	#        @campus = "ucsb"
	#      when /.*@.*berkeley.edu$/
	#        @campus = "ucb"
	#      when /.*@.*ucdavis.edu$/
	#        @campus = "ucd"
	#      when /.*@.*ucmerced.edu$/
	#        @campus = "ucm"
	#      when /.*@.*ucr.edu$/
	#        @campus = "ucr"
	#      when /.*@.*ucsf.edu$/
	#        @campus = "ucsf"
	#      when /.*@.*ucsc.edu$/
	#        @campus = "ucsc"
	#      else	
	#        @campus = "cdl"
	#      end
	#   end
 #   	@campus
 # 	end




    def link_to_remove_fields(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end


  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', :class => "add_fields btn", data: {id: id, fields: fields.gsub("\n", "")})
  end









end
