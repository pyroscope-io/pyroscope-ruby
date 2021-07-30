require "mkmf"

require 'net/http'

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]

LIB_DIRS = [LIBDIR, File.expand_path(File.join(File.dirname(__FILE__), "lib"))]

COMMIT = "39a3d9c"

# TODO: this is not very accurate, but it works for now
OS = RUBY_PLATFORM.include?("darwin") ? "mac" : "linux"
ARCH = RUBY_PLATFORM.include?("arm64") ? "arm64" : "amd64"

PREFIX = "/static-libs/#{COMMIT}/#{OS}-#{ARCH}"

ROOT = File.expand_path("..", __FILE__)

if ENV["PYROSCOPE_RUBY_LOCAL"]
  puts "PYROSCOPE_RUBY_LOCAL yes"
  system "cp #{ENV["HOME"]}/pyroscope/out/libpyroscope.rbspy.a #{File.join(ROOT, "lib/libpyroscope.rbspy.a")}"
  system "cp #{ENV["HOME"]}/pyroscope/out/librustdeps.a #{File.join(ROOT, "lib/librustdeps.a")}"
else
  Net::HTTP.start("dl.pyroscope.io", 443, :use_ssl => true) do |http|
    req = Net::HTTP::Get.new(PREFIX+"/libpyroscope.rbspy.combo.a.gz")
    http.request(req) do |resp|
      raise "HTTP error: #{resp.code}" unless resp.code == "200"

      r, w = IO.pipe

      t = Thread.new do
        zreader = Zlib::GzipReader.new(r)
        File.open(File.join(ROOT, "lib/libpyroscope.rbspy.combo.a"), "wb") do |f|
          loop do
            begin
              chunk = zreader.readpartial(32768)
              break if chunk.nil?
            rescue EOFError
              break
            end
            f.write(chunk)
          end
        end
      end

      resp.read_body do |chunk|
        w.write(chunk)
      end

      t.join
    end
  end
end

# this is now done upstream
# system "strip --strip-debug #{File.join(ROOT, "lib/libpyroscope.rbspy.combo.a")}"

dir_config('pyroscope', HEADER_DIRS, LIB_DIRS)

libs = ['-lpyroscope.rbspy.combo']
libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

create_makefile('pyroscope_c')
