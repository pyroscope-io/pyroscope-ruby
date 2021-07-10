require "mkmf"

require 'net/http'

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]

LIB_DIRS = [LIBDIR, File.expand_path(File.join(File.dirname(__FILE__), "lib"))]

# download specific commit for specific architecture
COMMIT = "8ebac5e"

OS = RUBY_PLATFORM.include?("darwin") ? "mac" : "linux"
ARCH = RUBY_PLATFORM.include?("arm64") ? "arm64" : "amd64"

PREFIX = "/static-libs/#{COMMIT}/#{OS}-#{ARCH}"

ROOT = File.expand_path("..", __FILE__)

Net::HTTP.start("dl.pyroscope.io", 443, :use_ssl => true) do |http|
  lib1 = http.get(PREFIX+"/libpyroscope.rbspy.a").body
  File.binwrite(File.join(ROOT, "lib/libpyroscope.rbspy.a"), lib1)
  lib2 = http.get(PREFIX+"/librustdeps.a").body
  File.binwrite(File.join(ROOT, "lib/librustdeps.a"), lib2)
end

libs = ['-lpyroscope.rbspy', '-lrustdeps']

dir_config('pyroscope', HEADER_DIRS, LIB_DIRS)

libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

create_makefile('pyroscope_c')
