class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz"
  sha256 "ea2725c6f38ddd8f3677c9b0ce8da8f52fe69e34aa85c01fb98074dc4e3458bc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "53dbe041047b4e19938e044fcd9eca3519b981f806b34866e7dbc9d8113b94fb" => :sierra
    sha256 "7d02546a1bbf772a78287ca2eda05a25e718be3039cc41f51e121b2fd3b976ea" => :el_capitan
    sha256 "bd9445f05761c8dd689effa3f131c9917632d8b6792afdd8e5be409f9e125e3b" => :yosemite
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-L#{lib}", "-lmpfi", "-o", "test"
    system "./test"
  end
end
