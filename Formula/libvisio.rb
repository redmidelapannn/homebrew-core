class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.5.tar.xz"
  sha256 "430a067903660bb1b97daf4b045e408a1bb75ca45e615cf05fb1a4da65fc5a8c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "ffab6266548ee41c204134076c0b0eb18fc2bde3db8b1206752054261ff06e0d" => :sierra
    sha256 "3e78f3d6eef0ba75998e91b7bc207a7cb9f72b87aa1041269aa7fd7028aba46f" => :el_capitan
    sha256 "96ae4ad25b5ddad10b8df1bc794f7d5b6c28019fbd174400b9dc2880cce312ad" => :yosemite
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
