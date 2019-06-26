class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.10-stable.tar.gz"
  sha256 "52c9db0bc5b148f146192aa517db0762b2a5b3060ccc63b2c470982ec72b9a79"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f0fa31d19954c93d36f36018fc7115575334a8dda3acd77c7f1101a9869778c" => :mojave
    sha256 "12e6896404aa5a34f4f1e9a85ad563b1d350ccda0cfa6e2bea3bd3a18f0bb27d" => :high_sierra
    sha256 "1433d4fa4fd7499514d874a41c5aee7c6bed99d53a47700d7ffe4480d4f72b60" => :sierra
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
    doc.install Dir["doxygen/html/*"]
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
