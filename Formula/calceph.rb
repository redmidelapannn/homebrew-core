class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.3.tar.gz"
  sha256 "8f27c05d7048b6b3f67c42824eebd158bae7bf257031c01d4912dd38a40b0218"

  bottle do
    cellar :any
    sha256 "b9a87188f491687719ebd09cb63cf6e5de073b2c884585e6809d49afe7c1c8a4" => :catalina
    sha256 "55c5b9c822b22b628be374b3699e1eb1bd9f9ebf70697568e268179631face4d" => :mojave
    sha256 "e372e289c99735cdd83a51d2de1d778a15a367212290cf5cedfd95e3746df380" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
