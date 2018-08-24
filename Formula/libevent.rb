class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz"
  sha256 "316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c30b88ad613192576e99455c5a3ec92dc45907dbfc7c389394d13df8ea70d40e" => :high_sierra
    sha256 "2acb2d67851c5538c134ddbcfed391216798a54066f5c3e195dd9c5625b0a595" => :sierra
    sha256 "9d76a16e08b41e9f1045a9537653ac9859f2e00feda509fe9e174144d4437da5" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end
