class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d1e5e2e58bc75385a8ff71dc9071035fbbbfe67b3ba79a8098e50299fe6e7c34" => :high_sierra
    sha256 "07b05cc68e36915519b53920dba61e39c0e94c0c38168d217819936ed7b96911" => :sierra
    sha256 "46aa72531a778d0b6f3b7e8fe260dd6a8a3e0c780a0b6ecde5c3ec6876b5c05e" => :el_capitan
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
