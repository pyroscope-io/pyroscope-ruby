require "pyroscope/version"
require "pyroscope_c"

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

  def self.stop
    _stop(Process.pid)
  end

  def self.change_name(new_name)
    _change_name(new_name, Process.pid)
  end
end
