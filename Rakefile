require "bundler/gem_tasks"
require "rubygems/package_task"
require "rake/extensiontask"
require "rake/testtask"
require "rspec/core/rake_task"
require "rake/clean"
require_relative "./lib/pyroscope/version"

CLEAN.include(
  "ext/pyroscope/*.o",
  "ext/pyroscope/*.bundle"
)

CLOBBER.include(
  "ext/pyroscope/Makefile",
  "pkg"
)

BUILD_DIR = 'build'

def gem_spec
  @gem_spec ||= Gem::Specification.load('pyroscope.gemspec')
end

Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::ExtensionTask.new("pyroscope_c", gem_spec) do |ext|
#  ext.name    = 'pyroscope'
  ext.ext_dir = './ext/pyroscope'
#  ext.lib_dir = 'lib/pyroscope'
  ext.tmp_dir = BUILD_DIR
  ext.config_script = "extconf.rb"
end

RSpec::Core::RakeTask.new(:spec)

task :build   => [:clean, :compile]

task :default => [:build, :spec]

task :test do
  # system "rsync -a /home/dmitry/rbspy/ /home/dmitry/pyroscope/third_party/local-clones/rbspy"
  # # system "cd ../pyroscope && DOCKER_BUILDKIT=1 docker build -f Dockerfile.static-libs --output type=local,dest=out ." if RUBY_PLATFORM.include?("linux")
  # system "cd ../pyroscope && rm out/*.a"
  # system "cd ../pyroscope && ENABLED_SPIES=rbspy make build-rust-dependencies"
  # system "cd ../pyroscope && make build-rbspy-static-library"
  # system "cd ../pyroscope && cp third_party/rustdeps/target/x86_64-unknown-linux-gnu/release/librustdeps.a ./out/librustdeps.a"
  extra_env = "PYROSCOPE_RUBY_LOCAL=1"
  extra_env = ""

  system "#{extra_env} rake build && #{extra_env} sudo -E gem install pkg/pyroscope-#{Pyroscope::VERSION}.gem && sudo -E ruby test.rb"
end

task :test_exec do
  # system "cd ../pyroscope && DOCKER_BUILDKIT=1 docker build -f Dockerfile.static-libs --output type=local,dest=out ." if RUBY_PLATFORM.include?("linux")
  system "sudo -E pyroscope exec ruby test.rb"
end

task :publish do
  system "rake build && gem install pkg/pyroscope-#{Pyroscope::VERSION}.gem && gem push pkg/pyroscope-#{Pyroscope::VERSION}.gem"
end
