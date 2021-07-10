require "pyroscope/version"
require_relative "./pyroscope_c"

module Pyroscope
  Config = Struct.new(:app_name, :server_address)

  def self.configure
    @configuration = Config.new
    yield @configuration
    _start(
      @configuration.app_name,
      Process.pid,
      @configuration.server_address,
    )
  end

  def stop
    _stop(Process.pid)
  end
end
