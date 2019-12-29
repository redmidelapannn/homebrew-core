class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.5.tar.xz"
  sha256 "6ace5c499a8be34ad871e825442ce388614ae2d8675c4381756a7319429e3a48"
  revision 1

  bottle do
    cellar :any
    sha256 "ced057ed5bfd03a97abcbb9da4410cae6932c1936a3a1897566a5f73f3f07270" => :catalina
    sha256 "077d8f4ad42f4057fe0ae6d09865162bf7b06e425da79aefd2e6d30967b924cb" => :mojave
    sha256 "f22448bf25b9f1cfbd3c8bf28f9b2681d68b220f4ef8cd2dffb2aceb7b6bf610" => :high_sierra
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
