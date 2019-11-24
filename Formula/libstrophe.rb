class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.3.tar.gz"
  sha256 "8a3b79f62177ed59c01d4d4108357ff20bd933d53b845ee4e350d304c051a4fe"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7fbc9729ba434f3ce34b73f01ae0a77a818cd440d4f3be2c84cf4b4542964ffd" => :catalina
    sha256 "97d342e1b130bf76d8ba5bfe8657aa9c64cd64b9883886fe59809b5c1f64d964" => :mojave
    sha256 "dc5d927b8809d506a115799e216a625c051f2d1e81df059a45b47b629c345533" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"
  uses_from_macos "libxml2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
    EOS
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
