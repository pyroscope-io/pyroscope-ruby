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
  s.homepage      = "http://rubygems.org/gems/pyroscope"
  s.license       = "Apache-2.0"
  s.require_paths = ["lib"]
  s.extensions    = []
end
