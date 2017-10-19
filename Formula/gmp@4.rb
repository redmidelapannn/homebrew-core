class GmpAT4 < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  # Track gcc infrastructure releases.
  url "https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.bz2"
  mirror "https://ftpmirror.gnu.org/gmp/gmp-4.3.2.tar.bz2"
  mirror "https://gmplib.org/download/gmp/archive/gmp-4.3.2.tar.bz2"
  mirror "https://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2"
  sha256 "936162c0312886c21581002b79932829aa048cfaf9937c6265aeaa14f1cd1775"

  bottle do
    cellar :any
    rebuild 2
    sha256 "cae8665c712f1915a97a9bc7d86411f9f2778d967a183f6375f9098489ae931c" => :high_sierra
    sha256 "908d15c8f228444c7823b8cf613a181d74d86d50989e0351afe9b290d0d22dc8" => :sierra
    sha256 "6bc064348e9d0450f8cc34b6ce7d16fa26ec77f64fc8ec962aa9887a8fdbe6c4" => :el_capitan
  end

  keg_only :versioned_formula

  fails_with :gcc_4_0 do
    cause "Reports of problems using gcc 4.0 on Leopard: https://github.com/mxcl/homebrew/issues/issue/2302"
  end

  # Patches gmp.h to remove the __need_size_t define, which
  # was preventing libc++ builds from getting the ptrdiff_t type
  # Applied upstream in http://gmplib.org:8000/gmp/raw-rev/6cd3658f5621
  patch :DATA

  def install
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    if MacOS.prefer_64_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--host=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Doesn't install in parallel on 8-core Mac Pro
    system "make", "install"

    # Different compilers and options can cause tests to fail even
    # if everything compiles, so yes, we want to do this step.
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>

      int main()
      {
        mpz_t integ;
        mpz_init (integ);
        mpz_clear (integ);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-I#{include}", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/gmp-h.in b/gmp-h.in
index d7fbc34..3c57c48 100644
--- a/gmp-h.in
+++ b/gmp-h.in
@@ -46,13 +46,11 @@ along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.  */
 #ifndef __GNU_MP__
 #define __GNU_MP__ 4

-#define __need_size_t  /* tell gcc stddef.h we only want size_t */
 #if defined (__cplusplus)
 #include <cstddef>     /* for size_t */
 #else
 #include <stddef.h>    /* for size_t */
 #endif
-#undef __need_size_t

 /* Instantiated by configure. */
 #if ! defined (__GMP_WITHIN_CONFIGURE)
