OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :google_oauth2, '97385814132-omb3h8so0fhsb82lr7klerm9pl8mr8is.apps.googleusercontent.com', 'TavWNTcyVkl3hUm8kvkKNGo0'

  provider :shibboleth, {  :request_type => :header,


                           :shib_session_id_field     => "Shib-Session-ID",
                           :shib_application_id_field => "Shib-Application-ID",
                           :debug                     =>  false,

                           :uid_field                 => "uid",
                           :name_field                => "displayName",
                           :info_fields => {
                               :email    => "mail",
                               :location => "contactAddress",
                               :image    => "photo_url",
                               :phone    => "contactPhone"
                           }
  }








end

