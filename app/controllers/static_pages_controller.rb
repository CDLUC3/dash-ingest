class StaticPagesController < ApplicationController
	include RecordHelper

  def contact
  	if request.post?
  		 		
  		msg = []
      msg.push('Please enter your name') if params[:name].blank?
      msg.push('Please enter your email') if params[:email].blank?
      msg.push('Please enter a message') if params[:message].blank?
      if !params[:email].blank? && !params[:email].match(/^\S+@\S+$/)
        msg.push('Please enter a valid email address')
      end
      if msg.length > 0    	
        flash.keep[:notice] = msg
        redirect_to contact_path(name: params['name'],
                                 email: params['email'], 
                                 message: params[:message]) and return
      end

      all_emails = APP_CONFIG['feedback_email_to'] #You can set the emails in config/app_config.yml
      all_emails.delete_if {|x| x.blank? } #delete any blank emails

      unless params[:content].present? # honeypot check
        all_emails.each do |email|
          GenericMailer.feedback_message(params, email).deliver
        end
      end

      #GenericMailer.feedback_message(params, email).deliver unless params[:content].present? # honeypot check

    	redirect_to :back, notice: "Your email message was sent to the Dash team."
    	return
  	
    end
  end



end
