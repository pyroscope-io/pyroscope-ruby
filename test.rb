require "pyroscope"

Pyroscope.configure do |config|
  config.app_name = "test.ruby.app"
  config.server_address = "http://pyroscope:4040/"
  config.tags = {
    :region => "us-east-1",
    :hostname => ENV["hostname"]
  }
end

def work(n)
  i = 0
  while i < n
    i += 1
  end
end

def fast_function
  work(20000)
end

def slow_function
  work(80000)
end

Pyroscope.tag({ "region" => "us-east-1" })

while true
  fast_function
  slow_function
end
