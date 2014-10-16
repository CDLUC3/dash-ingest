class Institution < ActiveRecord::Base
  attr_accessible :abbreviation, :external_id_strip, :landing_page, :long_name, :short_name, :campus, :logo, :shib_entity_id, :shib_entity_domain

  has_many :users


  # ROOT_URL = ENV["root_url"]



end
