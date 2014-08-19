class Institution < ActiveRecord::Base
  attr_accessible :abbreviation, :external_id_strip, :landing_page, :long_name, :short_name, :campus

  has_many :users
end
