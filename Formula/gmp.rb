class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz"
  sha256 "d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831"

  bottle do
    cellar :any
    rebuild 1
    sha256 "270c2fca26e90cc8f211d09b71de9c89e8e0ce21e429473922bcbb9736fa2538" => :sierra
    sha256 "c553c092e2c43dba1c63b3783d5f44d47938e2317728a71054df44a51e1a5501" => :el_capitan
    sha256 "8cca5fb8bd003195bd12bec6fc053fd88cbda9bdd2713a387d8899c7f9bb8a3c" => :yosemite
  end

  option "32-bit"
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]
    ENV["GMP_CPU_TYPE"] = Hardware.oldest_cpu

    if build.build_32_bit?
      ENV.m32
      args << "ABI=32"
    end

    args << "--enable-fake-cpuid" << "--enable-fat" if build.build_32_bit? || build.bottle?

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
