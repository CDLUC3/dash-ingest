
lock '3.2.1'

set :application, 'dash-ingest'
# set :repo_url, 'git@example.com:me/my_repo.git'
# Internal mercurial server
set :repo_url, 'https://auto:automaton@hg.cdlib.org/dash-ingest'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'default'
#set :branch, 'joel'
#set :branch, 'institutions'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/apps/dash/apps/dash-ingest'

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
set :linked_dirs, %w{uploads test_uploads log tmp/backup tmp/pids tmp/cache tmp/sockets}

set :stages, ["development", "staging", "production"]
set :default_stage, "development"

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 15

namespace :deploy do

  desc 'Stop Unicorn'
  task :stop do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, capture(:cat, fetch(:unicorn_pid))
      end
    end
  end

  desc 'Start Unicorn'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec unicorn -c #{fetch(:unicorn_config)} -D"
        end
      end
    end
  end

  desc 'Reload Unicorn without killing master process'
  task :reload do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, '-s USR2', capture(:cat, fetch(:unicorn_pid))
      else
        error 'Unicorn process not running'
      end
    end
  end

  desc 'Restart Unicorn'
  task :restart
  before "deploy:restart", "bundle:install"
  before :restart, :stop
  before :restart, :start
end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    on roles(:app) do
      execute "cd #{current_path} && bundle install --without=test"
    end
  end

end

