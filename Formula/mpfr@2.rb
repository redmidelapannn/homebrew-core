class MpfrAT2 < Formula
  desc "Multiple-precision floating-point computations C lib"
  homepage "http://www.mpfr.org/"
  # Track gcc infrastructure releases.
  url "http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2"
  sha256 "c7e75a08a8d49d2082e4caee1591a05d11b9d5627514e678f02d66a124bcf2ba"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65b58edc255ca86043d3836919f0ce53ccd7244f89bcb7b0d11df15ca83f280c" => :sierra
    sha256 "cb73259378eef08246ded9882514db8089f49637937c70de125d239a00d81b19" => :el_capitan
    sha256 "f71fed928714fc339986d9b943e4d4a6656696c61d9fd1ff76a4cca6e43afbbe" => :yosemite
  end

  keg_only "Older version of mpfr"

  depends_on "gmp@4"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/mxcl/homebrew/issues/15061
      EOS
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-gmp=#{Formula["gmp@4"].opt_prefix}
    ]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
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
    gmp = Formula["gmp@4"]
    system ENV.cc, "test.c", "-o", "test",
                   "-lgmp", "-I#{gmp.include}", "-L#{gmp.lib}",
                   "-lmpfr", "-I#{include}", "-L#{lib}"
    system "./test"
  end
end
