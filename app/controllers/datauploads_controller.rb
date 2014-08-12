class DatauploadsController < ApplicationController

  before_filter :verify_ownership
  
  def destroy
     @upload = Upload.find(params[:dataupload_id])
     @record = Record.find(@upload.record_id)
     @upload.destroy

     redirect_to "/record/#{@record.id}/uploads"
   end

   def verify_ownership 
     @user = User.find_by_id(session[:user_id])
     @record = Record.find_by_id(params[:id])
     #@institution = Institution.find_by_id(session[:institution_id])
     if @user
      @institution = @user.institution
    end
     if !@user.nil? && !@record.nil?
       if @record.user_id != @user.id
         redirect_to "/records"
       end
     end
  end
   
 end
