class GenericMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.generic_mailer.feedback_message.subject
  #
  def feedback_message(form_hash, email)
    @greeting = "Hello,  #{email}"
    @form_hash = form_hash
    mail  to: email,
          from: @form_hash[:email],
          subject: 'Dash Contact Us Form'
  end
end



# class GenericMailer < ActionMailer::Base
#   default :from => APP_CONFIG['feedback_email_from']

#   def contact_email(form_hash, email)
#     # values :question_about, :name, :email, :message
#     @form_hash = form_hash
#     mail :to => email,
#          :reply_to => form_hash[:email],
#          :subject => 'DMPTool2 Contact Us Form Feedback',
#          :from => APP_CONFIG['feedback_email_from']
#   end

# end