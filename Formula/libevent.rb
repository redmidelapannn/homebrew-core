class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz"
  sha256 "965cc5a8bb46ce4199a47e9b2c9e1cae3b137e8356ffdad6d94d3b9069b71dc2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "428217fe6f6f8b30b2916124df8662c4e1244cf5b05047fd410931aca10ea087" => :sierra
    sha256 "45bd1fe2c46575332335be7206f4f4dcc06f103da89d4c55b4ced13057bbad88" => :el_capitan
    sha256 "970520ac68301d9c9275595d41eeddeaf13852759b85e023ce56c2ed3e11a007" => :yosemite
  end

  head do
    url "https://github.com/libevent/libevent.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    system "./autogen.sh" if build.head?
    inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
