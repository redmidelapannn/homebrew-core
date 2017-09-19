class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.3.tar.gz"
  sha256 "159a13cd469d0645377377604c0fc4b3d3d1980d4d0e71c634c293f99db2c497"
  revision 2
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c867ca202d2299b9c3b98dc536c55737193492376da1fdb2d81e8c24c6579b31" => :sierra
    sha256 "937651a9c7c1d3b45dfd6a331ba7173efa38d6d4cd97dc75f8347cf9ba072493" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "libvorbis"
  depends_on "libzip"

  def install
    system "2to3", "--write", "--fix=print", "SConstruct"

    scons
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match /Version #{version}$/, shell_output("#{bin}/huexpress -h", 1)
  end
end
