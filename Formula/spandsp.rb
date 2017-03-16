class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://www.soft-switch.org/"
  url "https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c79717d764e7e6b7aa76eb0c9b2c38190ac8660a26550a11ad589c68b60ddafc" => :sierra
    sha256 "9a489a41f1d2f25cbbcfd98ec71026ecc4b81938a9e4555ded450870691ff0c4" => :el_capitan
    sha256 "9226f8a09bd9dba31822101e1dc60c668b9e096daf1ba1e3bfb519b0c8e5e10a" => :yosemite
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
