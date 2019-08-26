class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.1.3_src.tar.gz"
  sha256 "0f7644d91759771639216a722f24e1a9bebc0f6bbdd8ea55807b2b0df87ccb73"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c1dc46b272b4593269cf12b8704a90069e419f36ba776c17a677d11f9257cb42" => :mojave
    sha256 "4bc51bb8617ffb9664dc45297b33a26098b8596731eddfd42ae31b01dfa570f0" => :high_sierra
    sha256 "d15967b5d358a9086316132b9b88fc9a3286ef1306c5b56f5f2b1f667ad40db1" => :sierra
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
