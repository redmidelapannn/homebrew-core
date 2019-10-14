class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.5.tar.xz"
  sha256 "6ace5c499a8be34ad871e825442ce388614ae2d8675c4381756a7319429e3a48"
  revision 1

  bottle do
    cellar :any
    sha256 "7b6d3551c35dc3e4bc329a07c8141b8010c4674917d7f6d7711e6b1fc46fdbd0" => :catalina
    sha256 "a2ccbad8a8db41288fb7f38eded4548a46400177e51e016f1d6ec009bc7eaa2b" => :mojave
    sha256 "42619dd1c226d02d31dc6de0356e2b48096b90dac472964b34edfcf2f8081edc" => :high_sierra
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
