class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.4.tar.gz"
  sha256 "ae7a42df026550b85daca8389b6a60ba6313b0567f374392e54918588a411e94"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ced17a490b3395956c2a86fc5115e56ca55cb59726e980cc965445056f2bb5ce" => :high_sierra
    sha256 "fb6b0a3832d715f26a5f48bd4fbca442cac0da9900363cac76a6f58d3fcf9545" => :sierra
    sha256 "a01ac60b69e071f7bc7ce34531a966f9cc3373fdcf4023ae2a8e3368d2335f23" => :el_capitan
  end

  depends_on "gmp"

  def install
    # macOS doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib"

    # The LLVM shipped with Xcode/CLT 10+ compiles binaries/libraries with
    # ___chkstk_darwin, which upsets nettle's expected symbol check.
    # https://github.com/Homebrew/homebrew-core/issues/28817#issuecomment-396762855
    # https://lists.lysator.liu.se/pipermail/nettle-bugs/2018/007300.html
    if DevelopmentTools.clang_build_version >= 1000
      inreplace "testsuite/symbols-test", "get_pc_thunk",
                                          "get_pc_thunk|(_*chkstk_darwin)"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnettle", "-o", "test"
    system "./test"
  end
end
