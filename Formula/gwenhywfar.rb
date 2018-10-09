class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=208&file=02&dummy=gwenhywfar-4.20.0.tar.gz"
  sha256 "5a88daabba1388f9528590aab5de527a12dd44a7da4572ce48469a29911b0fb0"

  bottle do
    rebuild 1
    sha256 "bf20650ed86fac33f36051fc6df32e8b033a47794f5baee481b4897006a218ab" => :mojave
    sha256 "9b23f061001c3227667be3e14ac8132ede3c7bff27ac38289f55a79ed67ae7fa" => :high_sierra
    sha256 "15698f3400acfe6fd592151a70dc94b5c628f278d18435cdcd83394b57499796" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl"

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
