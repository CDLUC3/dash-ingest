class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :campus, :campus_short_name


  def login
    user = User.find_by_external_id(request.headers[DATASHARE_CONFIG['external_identifier']])
    if user.nil?
      user = User.new
      user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
      user.save
    end
    session[:user_id] = user.id
    redirect_to "/records"
  end


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

  def campus(user)
    if @user
      isTest ? "cdl" : Record.id_to_campus(user.external_id)
    else
      isTest ? "cdl" : url_to_campus
    end
  end

  #for displaying institution on Describe your dataset page
  def campus_short_name(user)
    isTest ? "UC Office of the President" : Record.id_to_campus_short_name(user.external_id)
  end

end
