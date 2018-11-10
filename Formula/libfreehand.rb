class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.2.tar.xz"
  sha256 "0e422d1564a6dbf22a9af598535425271e583514c0f7ba7d9091676420de34ac"
  revision 3

  bottle do
    cellar :any
    sha256 "e91c13498c61453e53d0b7b1fee4a16d4d8a0fcbbccbfa66bf66bc86e3412a90" => :mojave
    sha256 "ffafd744547221769726f7e667b4e6fa1720167f0a722f35729a2de9ea72ec0f" => :high_sierra
    sha256 "cf7ce50defff679dbf7847bb8e3144e1929b72621b3c931b4f3ccb364dd455ce" => :sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

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
    (testpath/"test.cpp").write <<~EOS
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
