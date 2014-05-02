
lock '3.2.1'

set :application, 'dash-ingest'
# set :repo_url, 'git@example.com:me/my_repo.git'
# Internal mercurial server
set :repo_url, 'https://auto:automaton@hg.cdlib.org/dash-ingest'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'default'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/apps/dash/apps/dash-ingest-test'

# Default value for :scm is :git
set :scm, 'hg'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/datashare.yml config/merritt.yml}

set :stages, ["development", "staging", "production"]
set :default_stage, "development"

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  #desc 'Restart application'
  #task :uptime do
    #on roles(:all) do |host|
      #execute :any_command, "with args", :here, "and here"
      #info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    #end
  #end

  desc 'Restart application'
  task :restart do
    # on roles(:app), in: :sequence, wait: 5 do
       # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    #end
  end

  #after :publishing, :restart

  #after :restart, :clear_cache do
    #on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    #end
  #end
  # make sure we're deploying what we think we're deploying
  # before :deploy, "deploy:check_revision"

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  # after 'deploy:publishing', 'deploy:restart'

end
