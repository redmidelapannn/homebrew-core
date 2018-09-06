class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-4-2/getdns-1.4.2.tar.gz"
  sha256 "1685b82dfe297cffc4bae08a773cdc88a3edf9a4e5a1ea27d8764bb5affc0e80"
  revision 2

  bottle do
    rebuild 1
    sha256 "a665b61f1f1f7a66045503e990adc5a1534eae00bc63766974072651476312c1" => :mojave
    sha256 "90eba1ed518bfb91c4c6bf3320ec472679e4c44bb102a6e4c8a033d0e3b62d6b" => :high_sierra
    sha256 "d1567fa3068ae6332fd1f4b9bca371a0759d5ac29f5e2203e3d5801b26aea7fc" => :sierra
    sha256 "30a69e9adf3c0a98e5d4a977d1ae71fab4b2c78bc5a8558ea3a4ca9ef31b2b1c" => :el_capitan
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libevent"
  depends_on "libidn"
  depends_on "openssl"
  depends_on "unbound"

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libevent",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-trust-anchor=#{etc}/getdns-root.key",
                          "--without-stubby"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <getdns/getdns.h>
      #include <stdio.h>

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
