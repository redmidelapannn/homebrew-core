class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "http://csl.sublevel3.org/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "67f9dd5e9c67710e15fc54db557cdb32ba3441a824d4ed4204268b2ea38e893c" => :sierra
    sha256 "f69ccf4ec814796a5d51a8ab5fdf980432e24f5fac769041069c5500f7fbf111" => :el_capitan
    sha256 "af103c525635059f50c618b3f634baf3ec2a194453c4f90709286836de1f05c4" => :yosemite
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
