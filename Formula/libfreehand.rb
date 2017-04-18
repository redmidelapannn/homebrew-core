class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.1.tar.xz"
  sha256 "ec6676d0c63f7feac7801a1fe18dd7abe9044b39c3882fc99b9afef39bdf1d30"
  revision 2

  bottle do
    cellar :any
    sha256 "79197ebadebb5a3a6709a77cfe9d72492b05e071ed1c1aa9a558510ef541627d" => :sierra
    sha256 "ec5da85fb6d1d5100d33c0ba08f74b67187d08389555bd97ac69c31183c2680c" => :el_capitan
    sha256 "f80c7e2c557b6fc5a6971b4bbfe1a18cfc582ca08e90aaa43f040a87d44520ba" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
