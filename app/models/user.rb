class User < ActiveRecord::Base

  has_many :records
  belongs_to :institution

  attr_accessible :external_id, :epsa, :email, :name, :uid, :user_email, :oauth_token, :institution_id

  def self.from_omniauth(auth,institution)

    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      if user.provider == "shibboleth"
      user.external_id = auth.info.external_id
      else
        user.external_id= auth.info.email
      end
      user.oauth_token = auth.credentials.token
      user.institution_id = institution
      user.save!

    end
  end

end

