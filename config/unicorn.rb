# config/unicorn.rb
if ENV["RAILS_ENV"] == "production"
  worker_processes 4
elsif ENV["RAILS_ENV"] == "staging" || ENV["RAILS_ENV"] == "stage"
  worker_processes 3
end

root = ENV["RAILS_ROOT"] || "/dash/apps/dash-ingest"
pid "#{root}/unicorn.pid"

timeout 5200

