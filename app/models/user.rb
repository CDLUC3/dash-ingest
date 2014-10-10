class User < ActiveRecord::Base
  
  has_many :records
  belongs_to :institution
  
  attr_accessible :external_id, :epsa, :email, :name, :uid, :user_email, :oauth_token, :oauth_expires_at

  def self.from_omniauth(auth,institution)
     # byebug
     # if ENV["RAILS_ENV"] == "local"
     #   user = User.find_by_id(36)
     #   user.save
     #
     #   else

     where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      #user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.external_id = auth.info.email
      user.institution_id = institution
      user.save!

    end
   # end
   end

  end




  # def self.institution
  #   url = ".ucop.edu"
  #   if ( url == nil )
  #     return Institution.find_by_id(1)
  #   end
  #   Institution.all.each do |i|
  #     if Regexp.new(i.landing_page).match(url)
  #       return i
  #     end
  #   end
  # end
  #
  #


