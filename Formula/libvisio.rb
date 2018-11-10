class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.6.tar.xz"
  sha256 "fe1002d3671d53c09bc65e47ec948ec7b67e6fb112ed1cd10966e211a8bb50f9"
  revision 5

  bottle do
    cellar :any
    sha256 "16014c3d9677935e8321de1c47b0779c8a1d926fef1065a337e7f5f88e3e3eaf" => :mojave
    sha256 "38eba11badcb475375a4655db3c382ccaf30974a2b34bee6b0d57793e8a4c302" => :high_sierra
    sha256 "95837cc86bb581e135f15fb585e4bc9acdd932ec50d8fb4c85ce8ce271d5c904" => :sierra
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"

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
    (testpath/"test.cpp").write <<~EOS
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
