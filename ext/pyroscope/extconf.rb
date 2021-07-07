require "mkmf"

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]

LIB_DIRS = [LIBDIR, File.expand_path(File.join(File.dirname(__FILE__), "lib"))]

libs = ['-lpyroscope.rbspy', '-lrustdeps']

dir_config('pyroscope', HEADER_DIRS, LIB_DIRS)

libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

create_makefile('pyroscope_c')
