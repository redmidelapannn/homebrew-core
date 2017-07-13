class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-1-2/getdns-1.1.2.tar.gz"
  sha256 "685fbd493601c88c90b0bf3021ba0ee863e3297bf92f01b8bf1b3c6637c86ba5"

  revision 1

  bottle do
    sha256 "182a0812774c9e21f5d88a1cc3c43d059d76daafbef904be947ca3779543d696" => :sierra
    sha256 "de1fb9d9f9f69492451dcd7b4d65e425a53eaa3e79a925eac90e3c5d711082a2" => :el_capitan
    sha256 "e67f390842a1422bdbed3f181fcce327c5823fc4544291f9453e8744317fb6bf" => :yosemite
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libidn" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key",
    ]
    args << "--enable-stub-only" if build.without? "unbound"
    args << "--without-libidn" if build.without? "libidn"
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libuv" if build.with? "libuv"
    args << "--with-libev" if build.with? "libev"

    # Current Makefile layout prevents simultaneous job execution
    # https://github.com/getdnsapi/getdns/issues/166
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--without-stubby", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      The Stubby DNS Privacy daemon has been moved to a separate formula; see stubby.
    EOS
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
