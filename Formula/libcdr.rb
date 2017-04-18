class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.3.tar.xz"
  sha256 "66e28e502abef7f6f494ce03de037d532f5e7888cfdee62c01203c8325b33f22"
  revision 3

  bottle do
    cellar :any
    sha256 "70073381bfcc31dd3cd932cf2f92bd35a771b451e12a4aab7e968851aaba3fb1" => :sierra
    sha256 "ebe0a4904601e4f86c553b8f8705144eeef1f94f8e0d4820846b83986e5db4e2" => :el_capitan
    sha256 "44c1e1c01206eca04bb8bf3d6bca3be2a5be27fc9509cffeed540dcd4776cebe" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-lcdr-0.1"
    system "./test"
  end
end
