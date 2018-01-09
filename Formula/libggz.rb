class Libggz < Formula
  desc "The libggz library wraps many common low-level functions"
  homepage "http://dev.ggzgamingzone.org/libraries/libggz/"
  url "https://mirrors.dotsrc.org/ggzgamingzone/ggz/0.0.14.1/libggz-0.0.14.1.tar.gz"
  mirror "http://ftp.belnet.be/mirror/ftp.ggzgamingzone.org/ggz/0.0.14.1/libggz-0.0.14.1.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libggz/libggz-0.0.14.1.tar.gz"
  sha256 "54301052a327f2ff3f2d684c5b1d7920e8601e13f4f8d5f1d170e5a7c9585e85"

  bottle do
    cellar :any
    rebuild 1
    sha256 "127d6ee6beb6d2df8c932ed065bfa623adc966b6b2480fb086c3cb6e61a8a4bf" => :high_sierra
    sha256 "46b779adb26b7173363a445d986a7ff09d86dda579c4a111d0a6d70c782155d1" => :sierra
    sha256 "f1f7b77d909c8a3d7fbccfdf6f854e0bdbbb05707e40966e532992596cb0a62f" => :el_capitan
  end

  # Libggz of this version is unable to build with gnutls-30 and later.
  depends_on "libgcrypt"
  depends_on "gettext"

  def install
    ENV.append "CPPFLAS", "-I#{Formula["gettext"].opt_prefix}/include"
    ENV.append "LDFLAGS", "-L#{Formula["gettext"].opt_prefix}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gcrypt"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>

      #include <ggz.h>

      int main(void)
      {
        int errs = 0;
        char *teststr, *instr, *outstr;

        teststr = "&quot; >< &&amp";
        instr = teststr;
        outstr = ggz_xml_escape(instr);
        instr = ggz_xml_unescape(outstr);
        if(strcmp(instr, teststr)) {
          errs++;
        }
        ggz_free(instr);
        ggz_free(outstr);
        ggz_memory_check();

        return errs;
      }
    EOS
    system ENV.cc, "test.c", ENV.cppflags, "-L/usr/lib", "-L#{lib}", "-lggz", "-o", "test"
    system "./test"
  end
end
