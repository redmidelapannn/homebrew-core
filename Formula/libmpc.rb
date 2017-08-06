class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://multiprecision.org"
  url "https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz"
  mirror "http://multiprecision.org/mpc/download/mpc-1.0.3.tar.gz"
  sha256 "617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1a5959388a9b1541bbdb1051e917b374d1dde46e0e6f35e26852ad43aafbe1b0" => :sierra
    sha256 "dc62002b5f7e37e2261e78aa05c07b63395bb20c842f33558ce1d9d911a2c919" => :el_capitan
    sha256 "f34a6f6292598008710d2e759a1fb14e5fe98a02083a2e97a0734e3e6127db3c" => :yosemite
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpc.h>
      #include <assert.h>
      #include <math.h>

      int main() {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_set_d_d (x, 1., INFINITY, MPC_RNDNN);
        mpc_tanh (x, x, MPC_RNDNN);
        assert (mpfr_nan_p (mpc_realref (x)) && mpfr_nan_p (mpc_imagref (x)));
        mpc_clear (x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-lmpc", "-o", "test"
    system "./test"
  end
end
