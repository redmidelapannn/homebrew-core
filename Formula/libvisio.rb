class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.5.tar.xz"
  sha256 "430a067903660bb1b97daf4b045e408a1bb75ca45e615cf05fb1a4da65fc5a8c"
  revision 3

  bottle do
    cellar :any
    sha256 "b018627a63f4512bda2f7fca481ec4c89d0b19eb89317428cb961fbf92ecde73" => :sierra
    sha256 "aaf64dbc3ec507c718dc8817b54ef9f301fed0d8ebf6e287d265f2a2e2a8496f" => :el_capitan
    sha256 "8dfb89bdcd48af06773ad0119973b28d4321cc0fd7c0b210a7b59954e0a59596" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
  depends_on "boost"
  depends_on "librevenge"
  depends_on "icu4c"

  def install
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--without-docs",
                          "-disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
