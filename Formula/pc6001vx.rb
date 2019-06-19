class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.0.0_src.tar.gz"
  sha256 "ab8915407833d95f4b38e9d86b14f548c9f6431eaa324eb046b3ef4fc95a8f51"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e13ee842e73e3cc2e2c603285a39b7446762817aae363df12660f0e6d8ec1de4" => :mojave
    sha256 "992191e2b87256a59c3d16a6a106d1a3e3d719963c7d3357adc643c6707014a5" => :high_sierra
    sha256 "104def14b2785784c734c1b3ae868d366d9d14c2ebf65230ebaba11437995c66" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["sdl2"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"
    # Turn off errors on C++11 build which used for properly linking standard lib
    ENV.append_to_cflags "-Wno-reserved-user-defined-literal"
    # Use libc++ explicitly, otherwise build fails
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang

    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
