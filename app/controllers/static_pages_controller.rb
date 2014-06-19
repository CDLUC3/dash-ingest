class StaticPagesController < ApplicationController
	include RecordHelper

  def contact
  	if request.post?
  		GenericMailer.feedback_message.deliver
  	end
  end



end
