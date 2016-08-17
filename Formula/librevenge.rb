class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "http://dev-www.libreoffice.org/src/librevenge-0.0.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.4/librevenge-0.0.4.tar.bz2"
  sha256 "c51601cd08320b75702812c64aae0653409164da7825fd0f451ac2c5dbe77cbf"

  bottle do
    cellar :any
    revision 1
    sha256 "9b33864970dff6f85fab2ef3a5fb76e2f2c71c2dc36281210c28fc2c5fcc1d56" => :el_capitan
    sha256 "3c95d9f294291a9d520b5cdf93f9411872fe257f5974bb3c3c5c04a56cd623ed" => :yosemite
    sha256 "166d24bcd6cc936c63695a18523ca88d35cd39af13bb855e8167af022f75b9a6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
