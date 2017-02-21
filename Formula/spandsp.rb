class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "http://www.soft-switch.org/"
  url "http://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f17add95f6c557dbf6340533298e1fe4952dcb8768e4e6efd78e3d14e3378894" => :sierra
    sha256 "021631a995d4820e8f77db0b3c0428d33e69331deb5cd15650636ec75fac74cc" => :el_capitan
    sha256 "d80decbafbe86d93e7520575be66a88722270b492c1c753afc20ac8fec8b873a" => :yosemite
  end

  depends_on "libtiff"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
      #include <spandsp.h>

      int main()
      {
        t38_terminal_state_t t38;
        memset(&t38, 0, sizeof(t38));
        return (t38_terminal_init(&t38, 0, NULL, NULL) == NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspandsp", "-o", "test"
    system "./test"
  end
end
