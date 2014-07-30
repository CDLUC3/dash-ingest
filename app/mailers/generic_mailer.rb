class GenericMailer < ActionMailer::Base
  default from: "ContacUs@dash.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.generic_mailer.feedback_message.subject
  #
  def feedback_message(form_hash, email)
    @form_hash = form_hash
    @campus = @form_hash[:campus]
    @greeting = "Hello #{email}"
    
    mail  to: email,
          reply_to: @form_hash[:email],
          subject: 'Dash Contact Us Form'#,
          #from: @form_hash[:email]
  end
end


#All emails should also go to uc3@ucop.edu
#For Berkeley - Copy of email should go to webman@library.berkeley.edu
#Email To fields should be configurable and based off of the campus URL. 
