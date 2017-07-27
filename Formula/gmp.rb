class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
  sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"

  bottle do
    cellar :any
    rebuild 2
    sha256 "6189262a57d89574ffaa095710d08d0a0ecaa0a58afdb8d7bd62a480c1a6cad9" => :sierra
    sha256 "1f68ecc5d91b50685944c4d0588c7beff89661c89bc6db3406f70f26ab988daf" => :el_capitan
    sha256 "38420f326d31417b7b3fe5ca36ad93f0b1747f501eb48f4726f98a878d6fa908" => :yosemite
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = %W[--prefix=#{prefix} --enable-cxx]
    args << "--build=core2-apple-darwin#{`uname -r`.to_i}" if build.bottle?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
