class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.0.1.tar.gz"
  sha256 "cb0cdd8d0954fcfd97a689077568f286cdbb44111883e0a85d29860449c47cbf"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "a0d89e76ea9045754883b9da2c50fdfb6e85d05479a75758651233935a42280f" => :mojave
    sha256 "eb3dc1cc42ff66b0bc8df91c9fbcd2dd60ae0e8bcccb0c61e93547c72e7ea079" => :high_sierra
    sha256 "fdad0520559eca29e73fce404ada9cfe579b26903e4a58973ad8924cb5e6b8f3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
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
