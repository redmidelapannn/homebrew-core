class Libhid < Formula
  desc "Library to access and interact with USB HID devices"
  homepage "https://directory.fsf.org/wiki/Libhid"
  url "https://pkg.freebsd.org/ports-distfiles/libhid-0.2.16.tar.gz"
  sha256 "f6809ab3b9c907cbb05ceba9ee6ca23a705f85fd71588518e14b3a7d9f2550e5"

  bottle do
    cellar :any
    rebuild 2
    sha256 "fb4feb1cd2185077b0aa7157e28077c509da301d22763edb2a0b2dd19453c2f7" => :catalina
    sha256 "b137013764a442e7d9c899deda12e6ae1e7347e0366648b12d4d721dd57f4b41" => :mojave
    sha256 "abcbc6bab75e256763bb0caa42429abe7a11bfa2ba52addcca705a674d91a8d1" => :high_sierra
  end

  depends_on "libusb"
  depends_on "libusb-compat"

  # Fix compilation error on 10.9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/libhid/0.2.16.patch"
    sha256 "443a3218902054b7fc7a9f91fd1601d50e2cc7bdca3f16e75419b3b60f2dab81"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <hid.h>
      int main(void) {
        hid_init();
        return hid_cleanup();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhid", "-o", "test"
    system "./test"
  end
end
