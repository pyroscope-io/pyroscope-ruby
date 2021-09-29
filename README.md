# Pyroscope Ruby Integration

### What is Pyroscope
[Pyroscope](https://github.com/pyroscope-io/pyroscope) is a tool that lets you continuously profile your applications to prevent and debug performance issues in your code. It consists of a low-overhead agent which sends data to the Pyroscope server which includes a custom-built storage engine. This allows for you to store and query any applications profiling data in an extremely efficient and cost effective way. 


### How to install Pyroscope for Python Applications
Adding Pyroscope to your Gemfile
```
bundle add pyroscope
```

### Basic Usage of Pyroscope
```
require 'pyroscope'

Pyroscope.configure do |config|
  config.application_name = "my.ruby.app" # replace this with some name for your application
  config.server_address   = "http://my-pyroscope-server:4040" # replace this with the address of your pyroscope server
end
```

### Adding Tags
Tags allow for users to view their data at different levels of granularity depending on what "slices" make sense for their application. This can be anything from region or microservice to more dynamic tags like controller or api route.

```
require 'pyroscope'

Pyroscope.configure do |config|
  config.application_name = "my.ruby.app"
  config.server_address   = "http://my-pyroscope-server:4040"

  config.tags = {
    "hostname" => ENV["HOSTNAME"],
  }
end

# You can use a wrapper:
Pyroscope.tag_wrapper({ "controller": "slow_controller_i_want_to_profile" }) do
  slow_code
end
```


### Examples
For more examples see [examples/ruby](https://github.com/pyroscope-io/pyroscope/tree/main/examples/ruby) in the main repo.

