lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pyroscope/version'

Gem::Specification.new do |s|
  s.name          = "pyroscope"
  s.version       = Pyroscope::VERSION
  s.summary       = "pyroscope"
  s.description   = "pyroscope client integration for ruby"
  s.authors       = ["Pyroscope Team"]
  s.email         = "contact@pyroscope.io"
  s.files         = `git ls-files`.split("\n")
  s.files         += Dir.glob("ext/**/**")
  # s.files         << "lib/pyroscope_c.bundle"
  s.homepage      = "http://rubygems.org/gems/pyroscope"
  s.license       = "Apache-2.0"
  s.require_paths = ["lib"]
  s.require_paths << "ext/pyroscope"
  s.extensions    << "ext/pyroscope/extconf.rb"

  s.add_development_dependency "rake"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rubygems-tasks"
  s.add_development_dependency "rspec"
end
