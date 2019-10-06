class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.0.tar.gz"
  sha256 "f176f8356d6a3514c60956386260986ee3bc98f5111b1e2bcc83581bbed20f1d"

  depends_on "gcc" # to enable fortran API

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <stdio.h>
      #include <calceph.h>
      #include <assert.h>
      int errorfound;
      static void myhandler(const char *msg)
      {
              puts(msg);
              errorfound = 1;
      }

      int main(void)
      {
          t_calcephbin * eph;

          errorfound = 0;
          calceph_seterrorhandler(3, myhandler);
          eph = calceph_open("example1.dat");
          assert(errorfound==1);
          return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
