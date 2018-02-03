class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.9.tar.gz"
  sha256 "2472f8d93830d0952b0c75f67e372d38c8f7c174dde2252369d5b20c87d3ba8e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "acb106ae96e0675bcc09469f534adb7f9eeac894459eee37d38fa507c127dcc3" => :high_sierra
    sha256 "449522499f6758a6f12a8abfcc921618f6728737daa077215ddb737c1d70dcd5" => :sierra
    sha256 "a596ded28181749f43489ccd1d3b08aa0e6f4b768a78450aa13fe73bf6d2fd0a" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
