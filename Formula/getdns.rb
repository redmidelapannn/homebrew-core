class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-1-0/getdns-1.1.0.tar.gz"
  sha256 "aa47bca275b97f623dc6799cee97d3465fa46521d94bd9892e08e8d5d88f09c3"

  bottle do
    sha256 "ae1cc45ff5e1e1ff4ea0c81a9e0e85b525042bd584da6c38eedda9cc50014440" => :sierra
    sha256 "c444e89e8948b4fca12f2b78483fde093b8fbaf1d6fee9a5800ed64ac0fc8009" => :el_capitan
    sha256 "df10db6c8082a1484d8b8000c2ef48a83c9e680f37d1d6bba3ede1126cc59d58" => :yosemite
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = %W[
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-trust-anchor=#{etc}/getdns-root.key
    ]
    # stringprep support was seemingly dropped in libidn2.
    args << "--without-libidn"

    args << "--enable-stub-only" if build.without? "unbound"
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libuv" if build.with? "libuv"
    args << "--with-libev" if build.with? "libev"

    # Current Makefile layout prevents simultaneous job execution
    # https://github.com/getdnsapi/getdns/issues/166
    ENV.deparallelize

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <getdns/getdns.h>

      int main(int argc, char *argv[]) {
        getdns_context *context;
        getdns_dict *api_info;
        char *pp;
        getdns_return_t r = getdns_context_create(&context, 0);
        if (r != GETDNS_RETURN_GOOD) {
            return -1;
        }
        api_info = getdns_context_get_api_information(context);
        if (!api_info) {
            return -1;
        }
        pp = getdns_pretty_print_dict(api_info);
        if (!pp) {
            return -1;
        }
        puts(pp);
        free(pp);
        getdns_dict_destroy(api_info);
        getdns_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
