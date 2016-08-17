class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.3.tar.xz"
  sha256 "943e03b1e6c969af4c2133a6671c9630adf3aaf8d460156744a28f58c9f47cd8"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "42ec1d59def4163529b1cffad2a6e0e459b7db27369ef2349fc7fea66251a9e4" => :el_capitan
    sha256 "006b1fd20d98b8cad6fa37bf8d56fd40d667430f15cd4ceb42b32fdfb8d3a308" => :yosemite
    sha256 "dedf2b7c5dd746a7901cac9c7616fe7aedc8875b3bf300cc8c69bf4f6d8c0463" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
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
