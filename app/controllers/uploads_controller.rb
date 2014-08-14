class UploadsController < ApplicationController

  def index

    @record_id = params[:record_id]

    @user = User.find_by_id(session[:user_id])
    @record = Record.find_by_id(params[:record_id])

    if @user
      @institution = @user.institution
    else
      @institution = Institution.find_by_id(1)
    end

    if ! @record.nil?
      @record.purge_temp_files
    end

    @uploads = Upload.find_all_by_record_id(params[:record_id])

    if @record.nil?
      redirect_to "/records"

    elsif @record.user_id != @user.id
        redirect_to "/records"
    else 

      if @record_id == nil
        raise ActionController::RoutingError.new('Not Found')
      else
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
        end
      end
    end
  end


  # POST /uploads
  # POST /uploads.json
  def create
         
     @temp_upload = Upload.new(params[:upload])
     
     if @temp_upload.record.nil?
       @temp_upload.record = Record.find(params[:record_id])
     end
     
     @upload = Upload.where(:record_id => @temp_upload.record_id, :upload_file_name => @temp_upload.upload_file_name).first

     if @upload.nil?
       @upload = Upload.create(params[:upload])
     else
       if @upload.upload_file_size.nil?
         @upload.upload_file_size = @temp_upload.upload_file_size
       else
         @upload.upload_file_size += @temp_upload.upload_file_size
       end
       
     end
     
    
    p = params[:upload]
    name = p[:upload].original_filename
    directory = "#{DATASHARE_CONFIG['uploads_dir']}/" + Record.find(@upload.record_id).local_id
    
    path = File.join(directory, "temp_" + name.gsub(" ","_"))
    File.open(path, "ab") { |f| f.write(p[:upload].read) }
    
    # delete jquery, switch to temp
    
    respond_to do |format|
      if @upload.save
      
        format.html {
          render :json => [@upload.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
          
        }
        format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  # note - this is needed for javascript delete
  # delete for existing server files is in datauploads_controller
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    @user = User.find_by_id(session[:user_id])
    @record = @upload.record

    if @record.nil?
      redirect_to "/records"

    elsif @record.user_id != @user.id
        redirect_to "/records"
    else
      respond_to do |format|
        format.html { redirect_to uploads_url }
        format.json { head :no_content }
      end
    
    end
  end  
  
end
