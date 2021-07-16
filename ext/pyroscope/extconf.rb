require "mkmf"

require 'net/http'

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]

LIB_DIRS = [LIBDIR, File.expand_path(File.join(File.dirname(__FILE__), "lib"))]

COMMIT = "24effc7"

# TODO: this is not very accurate, but it works for now
OS = RUBY_PLATFORM.include?("darwin") ? "mac" : "linux"
ARCH = RUBY_PLATFORM.include?("arm64") ? "arm64" : "amd64"

PREFIX = "/static-libs/#{COMMIT}/#{OS}-#{ARCH}"

ROOT = File.expand_path("..", __FILE__)

Net::HTTP.start("dl.pyroscope.io", 443, :use_ssl => true) do |http|
  res1 = http.get(PREFIX+"/libpyroscope.rbspy.a")
  raise "HTTP error: #{res1.code}" unless res1.code == "200"
  lib1 = res1.body
  File.binwrite(File.join(ROOT, "lib/libpyroscope.rbspy.a"), lib1)

  res2 = http.get(PREFIX+"/librustdeps.a")
  raise "HTTP error: #{res2.code}" unless res2.code == "200"
  lib2 = res2.body
  File.binwrite(File.join(ROOT, "lib/librustdeps.a"), lib2)
end

# TODO: figure out how to fix this bug
system "strip --strip-debug #{File.join(ROOT, "lib/libpyroscope.rbspy.a")}"

# system "cp /Users/dmitry/Dev/ps/pyroscope/out/libpyroscope.rbspy.a #{File.join(ROOT, "lib/libpyroscope.rbspy.a")}"
# system "cp /Users/dmitry/Dev/ps/pyroscope/third_party/rustdeps/target/release/librustdeps.a #{File.join(ROOT, "lib/librustdeps.a")}"

dir_config('pyroscope', HEADER_DIRS, LIB_DIRS)

libs = ['-lpyroscope.rbspy', '-lrustdeps']
libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

create_makefile('pyroscope_c')
