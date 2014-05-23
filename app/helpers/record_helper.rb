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
     "UC San Francisco" => "University of California, San Francisco" }
DataType = {
     "Audiovisual" => "Audiovisual,Audiovisual",
     "Collection" => "Collection,Collection",
     "Dataset" => "Dataset,Dataset",
     "Image" => "Image,Image",
     "Poster" => "Other,Poster",
     "Presentation" => "Other,Presentation",
     "Software" => "Software,Software",
     "Sound" => "Sound,Sound",
     "Text" => "Text,Text" }

  def user
    user = @user.external_id
  end

  def campus
    isTest ? campus = "cdl" : campus = Record.id_to_campus(user)
  end
  
  def institution
    Institution
  end
  def datatype
    DataType
  end
  def resourceType (x)
     x.split(",")[0]
  end
  def resourceTypeGeneral (x)
     x.split(",")[1]
  end
end
