Installation Instructions:

I. Development

These instructions will get you up and running with a development instance of DataIngest.  The application will be functional, but you will not be able to submit any records/data to Merritt without an account (step II below).

NOTE: This application currently requires a unix OS (tested on OS X and Centos/RedHat).  It uses a unix command line utility (CURL) for transmission of large files.  It most likely would not be difficult to adapt to windows or another environment.  

1. Install and configure Ruby 1.9.3

2. Download the app 

https://bitbucket.org/datashare/DataIngest


3. From the root rails directory, run
% bundle install

4. Run rake db:migrate
NOTE: the application is set up to use sqlite in development.  We've experienced database locking issues when trying to use sqlite in multiuser environments, particularly during large, chunked file uploads which require repeated database calls.  For a multiuser environment, you may want to use mysql or a different database.  A sample mysql yml file is included.

5. Run the unit tests
From the root directory, run 

% rake test.  

As of this writing, test coverage is around 95%.

6. Start a development rails server
% rails server

7. "Log In"
Open a browser window and navigate to localhost:3000 
(assuming you started your server on port 3000)

NOTE: if you experience a problem, try logging in at

http://localhost:3000/login

This will create a single user for development mode.  


II.  Configure application to use a Merritt Repository

1. Obtain a user space and account credentials from merritt:

2. Configure the merritt-yml file

merritt_endpoint: "https://merritt-stage.cdlib.org/object/ingest"
merritt_username: "username"
merritt_password: "password"
merritt_profile: "repository_name_submitter_content"

(you will receive these parameters from merritt when you create your account)

NOTE: I strongly advise against adding these parameters to your test configuration unless you want to send a file to merritt every time you run the integration tests

3. Create and submit a record.

4. Verify the upload.
You may receive an email from merritt indicating the status of your upload if your email address is on the notification list.  At this point, you can log into merritt directly to check the status of your upload.  

5. Load and index the record in datashare.
This step assumes you have installed and are running the XTF datashare application.  
See (bitbucket file) for more information.






