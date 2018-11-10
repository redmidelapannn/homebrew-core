class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.4.tar.xz"
  sha256 "e7a7e8b00a3df5798110024d7061fe9d1c3330277d2e4fa9213294f966a4a66d"
  revision 5

  bottle do
    cellar :any
    sha256 "9cf804b4a99622e37a302b780e1f705a2d87210a5d810dc4045fb960764f65e3" => :mojave
    sha256 "ae186822bc91c92eb9b1bd226344f6bc678f6836afbc45924db162b87ee44a07" => :high_sierra
    sha256 "a4e55e80e8d7061da2280548284911fd6c2d25a30cfb75bbf6547d94de100097" => :sierra
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--disable-werror",
                          "--without-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
