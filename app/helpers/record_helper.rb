module RecordHelper
# pull down menus
Institution = {
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

  def campus
    if @user
      isTest ? campus = "cdl" : campus = Record.id_to_campus(user)
    else
      isTest ? campus = "cdl" : campus = url_to_campus 
    end
  end

  #for setting record.publisher
  def campus_full_name
    isTest ? campus_full_name = "University of California, Office of the President" : campus_full_name = Record.id_to_campus_full_name(user)
  end

  #for displaying institution on Describe your dataset page
  def campus_short_name
    isTest ? campus_short_name = "UC Office of the President" : campus_short_name = Record.id_to_campus_short_name(user)
  end
  
  def institution
    Institution
  end
  def datatype
    DataType
  end
  def resourceType (x)
     x.split(",")[1]
  end
  def resourceTypeGeneral (x)
     x.split(",")[0]
  end
end
