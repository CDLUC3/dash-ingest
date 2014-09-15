require 'rack'

puts Rack::Session::Cookie::Base64::Marshal.new.decode(ARGV[0])