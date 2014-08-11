module RecordHelper
# pull down menus
Institutions = {
     "UC Berkeley" => "University of California, Berkeley",
     "UC Davis" => "University of California, Davis",
     "UC Irvine" => "University of California, Irvine",
     "UC Los Angeles" => "University of California, Los Angeles",
     "UC Merced" => "University of California, Merced",
     "UC Riverside" => "University of California, Riverside",
     "UC Santa Barbara" => "University of California, Santa Barbara",
     "UC Santa Cruz" => "University of California, Santa Cruz",
     "UC San Diego" => "University of California, San Diego",
     "UC San Francisco" => "University of California, San Francisco", 
     "UC Office of the President" => "University of California, Office of the President" }

DataType = {
     "Audiovisual" => "Audiovisual,Audiovisual",
     "Collection (multiple file types)" => "Collection,Collection",
     "Dataset" => "Dataset,Dataset",
     "Image" => "Image,Image",
     "Poster" => "Other,Poster",
     "Presentation" => "Other,Presentation",
     "Software" => "Software,Software",
     "Sound" => "Sound,Sound",
     "Text" => "Text,Text" }



  def user
    if @user
      user = @user.external_id
    else
      user = request.headers[DATASHARE_CONFIG['external_identifier']]
    end
  end


  #for setting record.publisher
  def campus_full_name(user)
    isTest ? "University of California, Office of the President" : Record.id_to_campus_full_name(user)
  end


#for setting record.publisher
  def institution_external_id(user)
    isTest ? "/.*@.*ucop.edu$/" : Record.institutions_db(user)
  end


  def set_session_institution(user)
    @external_id_strip = eval(institution_external_id(user))      
    @institution = Institution.where('external_id_strip REGEXP ?', @external_id_strip.source).first
    if @institution
      session[:institution_id] = @institution.id
    else
      session[:institution_id] = 1
    end
  end
  
  
  def institution
    Institutions
  end

  def datatype
    DataType
  end

  def resourceType(x)
     x.split(",")[1]
  end

  def resourceTypeGeneral(x)
     x.split(",")[0]
  end

end
