class StaticPagesController < ApplicationController

  def contact
    @user = User.find_by_id(session[:user_id])
    if @user
      @institution = @user.institution
    else
      @institution = Institution.find_by_id(1)
    end
    @campus = @institution.campus
    @campus_email = [campus_email(@campus)]
    
  	if request.post?
  		 		
  		msg = []
      msg.push('Please enter your name') if params[:name].blank?
      msg.push('Please enter your email') if params[:email].blank?
      msg.push('Please enter a message') if params[:message].blank?
      if !params[:email].blank? && !params[:email].match(/^\S+@\S+$/)
        msg.push('Please enter a valid email address')
      end

      all_emails = APP_CONFIG['feedback_email_to'] + @campus_email #You can set the emails in config/app_config.yml
      all_emails.delete_if {|x| x.blank? } #delete any blank emails

      if params[:content].present? || msg.length > 0 # honeypot check and validity check
        if params[:content].present?
          msg.push("Thanks.") #for the spam
        end
        flash[:notice] = msg
      else
        all_emails.each do |email|
          GenericMailer.feedback_message(params, email).deliver
        end
        flash[:notice] = "Your email message was sent to the Dash team."
      end
  	
    end
  end


  def campus_email(institution)
    if CAMPUS_EMAILS.has_key?(institution)
      CAMPUS_EMAILS[institution]
    else
      CAMPUS_EMAILS['unknown']
    end
  end 


end
