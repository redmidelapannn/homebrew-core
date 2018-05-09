class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.0.0.tar.gz"
  sha256 "a6b611c212c52f161f70556339fdaa199b7e9b6a167c4638e086d19db75d6290"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "29ae873cfbba0a1e9b4bcab599fd22ac8097bc607ce4d36ac4288617c7ebb509" => :high_sierra
    sha256 "137ad76d4def119c5524e085bda897202bc91a87132b7f336605c9d3524797e1" => :sierra
    sha256 "e9de1465e29a7535ec5142984af0abb042fe97ddb8717fe4682c126494b6f72d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
