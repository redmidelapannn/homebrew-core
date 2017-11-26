class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.1.tar.gz"
  sha256 "29414be4f79f6abc0e6aadccd09a4da0f0c431e3b5691f496acd081ae6a8240c"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "c31fae16d7b8257d714b7f6ac182c6ea0ef92fc28270ee68b28f83f54fb23cdb" => :high_sierra
    sha256 "51869c214fbd7df4913954808631f4d2b337ef7aaf0326c35ea9c2d88bb66d0b" => :sierra
    sha256 "5e17e179c8bfff4b0abe5d8be5f8066335b76b15db504c73abbd12637456ef70" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "libev"
  depends_on "libuv"
  depends_on "libevent"

  def install
    cmake_args = std_cmake_args.concat %w[
      -DLWS_WITH_LIBEV=ON
      -DLWS_WITH_LIBUV=ON
      -DLWS_WITH_LIBEVENT=ON
      -DLWS_WITH_HTTP2=ON
      -DLWS_IPV6=ON
      -DLWS_UNIX_SOCK=ON
      -DLWS_WITH_PLUGINS=ON
      -DLWS_WITHOUT_TESTAPPS=ON
    ]

    system "cmake", ".", *cmake_args
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
