require 'pyroscope'

# puts Pyroscope::Greeting.new("test").hello

# puts Pyroscope.methods
puts "prestart #{Process.pid}"
Pyroscope.start("test.ruby.app", Process.pid, "rbspy", "http://localhost:4040/")

puts "start"
i=0
while true
  i+=1
  # puts i if i%10000 == 0
end
