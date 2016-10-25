class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.91/upx-3.91-src.tar.bz2"
  mirror "https://fossies.org/linux/privat/upx-3.91-src.tar.bz2"
  sha256 "527ce757429841f51675352b1f9f6fc8ad97b18002080d7bf8672c466d8c6a3c"
  head "https://github.com/upx/upx.git", :branch => :devel
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bdbf016155ca3c01c4731db12392f42b12c4866e6c9dc687e7373ab8c1411f01" => :el_capitan
    sha256 "d021bdb9ae9f11ca36ef8bd596fde54e99a0e0863f9ca08520e7243d8ae19b31" => :yosemite
  end

  depends_on "ucl"

  # https://sourceforge.net/p/upx/bugs/248/
  # https://github.com/upx/upx/issues/4
  depends_on MaximumMacOSRequirement => :el_capitan

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
