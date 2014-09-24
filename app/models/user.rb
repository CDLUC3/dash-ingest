class User < ActiveRecord::Base
  
  has_many :records
  belongs_to :institution
  
  attr_accessible :external_id, :epsa, :email, :name, :uid, :user_email, :oauth_token, :oauth_expires_at

  def self.from_omniauth(auth,institution_id)


    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      # if auth[:provider] == 'google_oauth2'
      # user.provider = auth.provider
      # user.uid = auth.uid
      # user.email = auth.info.email
      # #user.name = auth.info.name
      # user.oauth_token = auth.credentials.token
      # #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      # user.external_id = auth.info.email
      # user.institution_id = 12
      # user.save!
      #
      # elsif

      user.provider = auth.provider
      user.uid = auth.uid
      user.institution_id = institution_id
      user.external_id = request.headers[DATASHARE_CONFIG['external_identifier']]
      user.institution_id = User.institution_from_shibboleth(request.headers[DATASHARE_CONFIG['external_identifier']]).id
      user.email = request.headers[DATASHARE_CONFIG['user_email_from_shibboleth']]
      user.first_name = request.headers[DATASHARE_CONFIG['first_name_from_shibboleth']]
      user.last_name = request.headers[DATASHARE_CONFIG['last_name_from_shibboleth']]
      user.save



      #end


      end

  end


  def self.from_omniauth(auth, institution_id)

  end


  def self.institution_from_shibboleth(id)
	  if ( id == nil )
	    return Institution.find_by_id(1)
	  end
	  Institution.all.each do |i|
	    if Regexp.new(i.external_id_strip).match(id)
	      return i
	    end
	  end
	end


end
