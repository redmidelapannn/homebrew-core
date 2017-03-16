class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://dev-www.libreoffice.org/src/libwps-0.4.2.tar.bz2"
  sha256 "254b8aeb36a3b58eabf682b04a5a6cf9b01267e762c7dc57d4533b95f30dc587"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93d6313bdc0bdd3025bea2b44768e64e11c9d1cd4b00fd112c8fd24aa2e699ed" => :sierra
    sha256 "33a415fb5f37f1169690d18dfa06724d6e5fe62a175ad0564ec5b81a98a312f2" => :el_capitan
    sha256 "4d4845fbe15ac582668e5f08dab6fc8f9898be51b1052457cc925709a36a44dd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lrevenge-0.0",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{Formula["librevenge"].lib}",
                  "-lwpd-0.10",
                  "-I#{Formula["libwpd"].include}/libwpd-0.10",
                  "-L#{Formula["libwpd"].lib}",
                  "-lwps-0.4", "-I#{include}/libwps-0.4", "-L#{lib}"
    system "./test"
  end
end
