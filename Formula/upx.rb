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
    sha256 "568f27765bbb7ee835597051afd95f64dcd5c320b55463ef0394ea98068683e4" => :sierra
    sha256 "6063dcac3a03bd5de76cac423266a232b0bf6c13255789e4790f79916930a828" => :el_capitan
    sha256 "76919d7e3ea98f9eaf76ea8f07e5deafb894acf9af256872aaa2af9f73f201b9" => :yosemite
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
