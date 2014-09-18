# config/unicorn.rb
if ENV["RAILS_ENV"] == "development"
  worker_processes 1
elsif ENV["RAILS_ENV"] == "staging" || ENV["RAILS_ENV"] == "stage"
  worker_processes 2
else
	worker_processes 10
end

root = ENV["RAILS_ROOT"] || "/dash/apps/dash-ingest"
pid "#{root}/unicorn.pid"

timeout 5200
application = "dash-ingest"
app_path = "/dash/apps/#{application}"

# logs
stderr_path "#{app_path}/current/log/unicorn.stderr.log"
stdout_path "#{app_path}/current/log/unicorn.stdout.log"

#logger Logger.new(File.join(Dir.pwd, "log", "unicorn.log"))
#logger Logger.new("#{app_path}/current/log/unicorn.log")
