require "pyroscope/version"
require "pyroscope_c"

module Pyroscope
  Config = Struct.new(:app_name, :server_address, :auth_token, :sample_rate, :with_subprocesses, :log_level)

  class << self
    def configure
      @configuration = Config.new
      yield @configuration
      _start(
        Process.pid,
        @configuration.app_name,
        @configuration.server_address,
        @configuration.auth_token || "",
        @configuration.sample_rate || 100,
        @configuration.with_subprocesses || 0,
        @configuration.log_level || "error",
      )
    end

    def stop
      _stop(Process.pid)
    end

    def change_name(new_name)
      _change_name(Process.pid, new_name)
    end

    def set_tag(key, val)
      _set_tag(Process.pid, key, val)
    end

    def test_logger()
      _test_logger
    end

    VALID_LOG_LEVELS = %i[none error info debug]

    def set_logger_level(level)
      i = VALID_LOG_LEVELS.index(level)
      raise "Unknown log level (#{level.inspect}), valid values are #{VALID_LOG_LEVELS.inspect}" unless i

      _set_logger_level(i - 1)
    end

    def build_summary
      _build_summary
    end
  end
end
