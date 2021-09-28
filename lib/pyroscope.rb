require "pyroscope/version"
require "pyroscope_c"

module Pyroscope
  Config = Struct.new(:app_name, :server_address, :auth_token, :sample_rate, :with_subprocesses, :log_level, :tags)

  class << self
    def configure
      @configuration = Config.new
      yield @configuration
      _start(
        @configuration.app_name,
        @configuration.server_address,
        @configuration.auth_token || "",
        @configuration.sample_rate || 100,
        @configuration.with_subprocesses || 0,
        @configuration.log_level || "error",
      )
      tag(@configuration.tags) if @configuration.tags
    end

    def stop
      _stop
    end

    def change_name(new_name)
      _change_name(new_name)
    end

    def tag_wrapper(tags)
      tag(tags)

      begin
        yield
      ensure
        remove_tags(*tags.keys)
      end
    end

    def tag(tags)
      tags.each_pair do |key, val|
        _set_tag(key.to_s, val.to_s)
      end
    end

    def remove_tags(*keys)
      keys.each do |key|
        _set_tag(key.to_s, "")
      end
    end

    def test_logger
      _test_logger
    end

    def build_summary
      _build_summary
    end
  end
end
