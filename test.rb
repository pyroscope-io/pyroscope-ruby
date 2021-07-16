require 'pyroscope'

puts "prestart #{Process.pid}"

Pyroscope.configure do |config|
  config.app_name = "test.app.ruby2.cpu{}"
  config.server_address = "http://localhost:4040/"
end

puts "start"
i=0
st = Time.new
while true
  i+=1
  # puts Time.new - st
  if Time.new - st > 5
    puts "new name " + "test.app.ruby2.cpu{iteration=#{i}}"
    Pyroscope.change_name("test.app.ruby2.cpu{iteration=#{i}}")
    st = Time.new
  end
end
