FactoryGirl.define do
  factory :user do
    external_id       "Fake.User-ucop.edu@ucop.edu"
    created_at        "2014-07-08 22:18:52"
    updated_at        "2014-07-08 22:18:52"
    email             nil
  end


  factory :institution do
    abbreviation        "UC"
    short_name          "UC Office of the president"
    long_name           "University of California, Office of the President"
    landing_page        "http://dash-dev.cdlib.org"
    external_id_strip   ".@.ucop.edu"
    created_at          "2014-08-08 03:32:00"
    updated_at          "2014-08-08 03:32:00"
    campus              "cdl"
    #logo                "blank_institution_logo.png"
  end


  factory :record do

    identifier         nil
    identifierType     nil
    publisher          "UC Office of the president"
    publicationyear    "2014"
    resourcetype       "Image,Image"
    rights             "Creative Commons Attribution 4.0 International (CC-..."
    created_at         "2014-08-11 19:31:52"
    updated_at         "2014-08-11 19:31:52"
    title              "sss"
    local_id           "uzkmimntnn"
    abstract           ""
    #methods            ""
    rights_uri         "https://creativecommons.org/licenses/by/4.0/"

  end


   #factory.define :record_with_creator, :parent => :record do |f|
     #f.creators { |record| [record.association(:creator)]}
  # end


  factory :creator do
     #association(:record)
    creatorName      "abc"

  end


  factory :subject do

  end

  factory :citation  do

  end


end