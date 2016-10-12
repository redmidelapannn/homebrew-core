class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.91/upx-3.91-src.tar.bz2"
  mirror "https://fossies.org/linux/privat/upx-3.91-src.tar.bz2"
  sha256 "527ce757429841f51675352b1f9f6fc8ad97b18002080d7bf8672c466d8c6a3c"
  head "https://github.com/upx/upx.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "53f23d1a66f9f20f3a3de4e2e4171f7d4ddf92ba26aff4d87d6bb8f21d47228b" => :sierra
    sha256 "65536b4e479ba21966e92d3298a9284c34f8696ae304a9be117dcae91c51240f" => :el_capitan
    sha256 "4a59137a52ac6052a280b9dfcfe0f252e6dac6e3f452b791a479086496b9ecbf" => :yosemite
  end

  depends_on "ucl"

  resource "lzma" do
    url "https://downloads.sourceforge.net/project/sevenzip/LZMA%20SDK/lzma938.7z"
    sha256 "721f4f15378e836686483811d7ea1282463e3dec1932722e1010d3102c5c3b20"
  end

  def install
    inreplace "src/compress_lzma.cpp", "C/Types.h", "C/7zTypes.h"
    (buildpath/"lzmasdk").install resource("lzma")
    ENV["UPX_LZMADIR"] = buildpath/"lzmasdk"
    ENV["UPX_LZMA_VERSION"] = "0x938"
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "cc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-1", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-d", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
