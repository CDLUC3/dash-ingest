class GenericMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.generic_mailer.feedback_message.subject
  #
  def feedback_message
    @greeting = "Hi"

    mail to: "shirin.faenza@ucop.edu"
  end
end
