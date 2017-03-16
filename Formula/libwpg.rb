class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.1.tar.bz2"
  sha256 "29049b95895914e680390717a243b291448e76e0f82fb4d2479adee5330fbb59"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17ada97febc1dac792313ccba2b97bdb14a889bd8f3263f507bd19f67bdb127c" => :sierra
    sha256 "9b5168cf295174e82189c1c355359bf8e1e0da67ce25e2dbf7fa787bdbde57a8" => :el_capitan
    sha256 "5cd2f1eaa47691ce5266a65eb6c303e7c5f1db728fcab6ddeaa7d63c6c7d62bd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpg-0.3", "-I#{include}/libwpg-0.3"
    system "./test"
  end
end
