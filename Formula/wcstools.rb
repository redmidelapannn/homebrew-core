class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.5.tar.gz"
  sha256 "b2f9be55fdec29f0c640028a9986771bfd6ab3d2f633953e4c7cc3b410e5fe9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aabc2d5b7f0f21866dac0b18da5fd75d31279d31ef5b6261f61f3f9f8d95bbd" => :catalina
    sha256 "f6143b1faa39a9cd3bdf7b3e754c41014d7b0104fd923c1f3d5529c6dbcfff39" => :mojave
    sha256 "a5097c96ba242d214adce6cec2d9fbb62cdb68ef120919758428ce1ffbd26b71" => :high_sierra
  end

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    assert_match "IMHEAD", shell_output("#{bin}/imhead 2>&1", 1)
  end
end
