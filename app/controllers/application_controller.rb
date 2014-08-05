class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :campus, :campus_short_name, :campus_to_url, :campus_to_url_name


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

  

  def url_to_campus_short 
    id = request.headers[DATASHARE_CONFIG['external_identifier']]
    if ( id == nil )
      @campus_short_name = "UC Office of the President"
    else
      case id.strip
      when /.*@.*ucop.edu$/
        @campus_short_name = "UC Office of the President"
       when /.*@.*uci.edu$/
         @campus_short_name = "UC Irvine"
       when /.*@.*ucla.edu$/
         @campus_short_name = "UC Los Angeles"
       when /.*@.*ucsd.edu$/
         @campus_short_name = "UC San Diego"
       when /.*@.*ucsb.edu$/
         @campus_short_name = "UC Santa Barbara"
       when /.*@.*berkeley.edu$/
         @campus_short_name = "UC Berkeley"
       when /.*@.*ucdavis.edu$/
         @campus_short_name = "UC Davis"
       when /.*@.*ucmerced.edu$/
         @campus_short_name = "UC Merced"
       when /.*@.*ucr.edu$/
         @campus_short_name = "UC Riverside"
       when /.*@.*ucsf.edu$/
         @campus_short_name = "UC San Francisco"
       when /.*@.*ucsc.edu$/
         @campus_short_name = "UC Santa Cruz"
       else  
         @campus_short_name = "UC Office of the President"
       end
    end
    @campus_short_name
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
    if @user
      isTest ? "UC" : Record.id_to_campus_short_name(user.external_id)
    else
      isTest ? "UC" : url_to_campus_short
    end
  end

#used as a link in the header
  def campus_to_url(campus)
    case campus
      when  "cdl"
        url = "http://dash-dev.ucop.edu"
      when "ucb"
        url = "https://dash-dev.berkeley.edu"
      when "ucla"
        url = "http://dev.dash.ucla.edu"  
      else 
       url = "http://dash-dev.cdlib.org"
    end
    url
  end


#used as a link in the header
  def campus_to_url_name(campus)
    case campus
      when  "cdl"
        name = "UC"
      when "ucb"
        name = "Berkeley"
      when "ucla"
        name = "UCLA"  
      else 
       name = "UC"
    end
    name
  end

end





















