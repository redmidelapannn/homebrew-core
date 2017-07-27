class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use mirrors
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mpfr4/mpfr4_3.1.5.orig.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.5.tar.xz"
  sha256 "015fde82b3979fbe5f83501986d328331ba8ddf008c1ff3da3c238f49ca062bc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9b5e46bf9a2901defe70f189924ec2d6b79936f124181e851032baca957463d2" => :sierra
    sha256 "1227d78bff859d7dc002667f37da1078430746ae988addfddb13d775ca24be67" => :el_capitan
    sha256 "d9d82d6009e5e1459630e7485e4caa1ebfcd85edee28c1b6b98588e606c60999" => :yosemite
  end

  depends_on "gmp"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
    EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_root (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
