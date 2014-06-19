class StaticPagesController < ApplicationController
	include RecordHelper

  def contact
  	GenericMailer.feedback_message.deliver
  end
end
