# config/unicorn.rb
if ENV["RAILS_ENV"] == "development"
  worker_processes 1
else
  worker_processes 3
end

root = ENV["RAILS_ROOT"] || "/dash/apps/dash-ingest"
pid "#{root}/unicorn.pid"

timeout 5200

