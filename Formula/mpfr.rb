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
    sha256 "72a42095f60d98e892e8d0fcacd69dd189d623982f4cf47ed6d626584a0cc4af" => :sierra
    sha256 "b5ca85732fb47adeecadb3053fa1d358a73bc71089659ff1ebec04cbf76158c6" => :el_capitan
    sha256 "3ae30594fa0d462a98403b7bd9ea525f68d76b482d7ed9f6d5f2240bddfba5aa" => :yosemite
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
      #include <gmp.h>
      #include <mpfr.h>

      int main()
      {
        mpfr_t x;
        mpfr_init(x);
        mpfr_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}", "-lgmp",
                   "-lmpfr", "-o", "test"
    system "./test"
  end
end
