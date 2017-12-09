class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.0.1.tar.xz"
  sha256 "a618f59051209d6d70c24cf42d64c9b67bd7dd5946b6dbd2c649181d7e8f1f6e"
  revision 1

  bottle do
    cellar :any
    sha256 "82c07b5812cdff7ed8906a0a739f764f464bc8954d1e9ddf91e6129da673f980" => :high_sierra
    sha256 "8100345c23713abd77b3bd1669e73a9a8e94defcba283cb951576a0815987c8b" => :sierra
    sha256 "f8afa09be30dc36d75b297e12764d050d340e59e87402c0ffe7ff35b1887b1d8" => :el_capitan
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"

  def install
    ENV["LIBSSL_LIBS"] = "-lssl -lcrypto -lz"
    ENV["LIBCRYPTO_LIBS"] = "-lcrypto -lz"
    ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u2f-server/u2f-server.h>
      int main()
      {
        if (u2fs_global_init(U2FS_DEBUG) != U2FS_OK)
        {
          return 1;
        }

        u2fs_ctx_t *ctx;
        if (u2fs_init(&ctx) != U2FS_OK)
        {
          return 1;
        }

        u2fs_done(ctx);
        u2fs_global_done();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lu2f-server"
    system "./test"
  end
end
