require 'pyroscope'

puts "prestart #{Process.pid}"

Pyroscope.configure do |config|
  config.app_name = "test.ruby.app{}"
  config.server_address = "http://localhost:4040/"
end

puts "start"
iteration=0
st = Time.new

puts "Pyroscope.test_logger 1"
Pyroscope.test_logger
Pyroscope.set_logger_level(:info)
puts "Pyroscope.test_logger 2"
Pyroscope.test_logger

puts "build_summary:"
puts Pyroscope.build_summary

def work(n)
  i = 0
  while i < n
    i += 1
  end
end

def job_0
  work(rand()*1_000_000)
end

def job_1
  work(rand()*2_000_000)
end

def sleep_job
  sleep(rand()*10)
end


while true
  iteration+=1

  r = rand
  # if r > 0.9
  #   Pyroscope.set_logger_level(:test)
  # end
  if r < 0.1
    sleep_job
  elsif r < 0.5
    puts(" * test.ruby.app{job=0}")
    Pyroscope.change_name("test.ruby.app{job=0}")
    job_0
    Pyroscope.change_name("test.ruby.app{}")
  else
    puts(" * test.ruby.app{job=1}")
    Pyroscope.change_name("test.ruby.app{job=1}")
    job_1
    Pyroscope.change_name("test.ruby.app{}")
  end
end
