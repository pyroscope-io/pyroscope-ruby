require 'pyroscope'

puts "prestart #{Process.pid}"

Pyroscope.configure do |config|
  config.app_name = "test.app.ruby.cpu"
  config.server_address = "http://localhost:4040/"
end

puts "start"
i=0
while true
  i+=1
  # puts i if i%10000 == 0
end
