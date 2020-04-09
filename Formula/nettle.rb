class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.5.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.4.1.tar.gz"
  sha256 "75cca1998761b02e16f2db56da52992aef622bf55a3b45ec538bc2eedadc9419"

  bottle do
    cellar :any
    sha256 "aa005de1c5b60a48ad73c8c5a19c1cc498a34a9cadfdb5727c65daf456986107" => :catalina
    sha256 "884b274f8fb64a0d257cf674b47b08b3f0505a54e2f1d1608aaf3f67211aef4c" => :mojave
    sha256 "be426496f9eec6a235fa13d180beea5704cfcba76b5085c46859a2ebf9828c46" => :high_sierra
  end

  depends_on "gmp"

  uses_from_macos "m4" => :build

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
