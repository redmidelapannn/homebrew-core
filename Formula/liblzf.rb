class Liblzf < Formula
  desc "Very small, very fast data compression library"
  homepage "http://oldhome.schmorp.de/marc/liblzf.html"
  url "http://dist.schmorp.de/liblzf/liblzf-3.6.tar.gz"
  mirror "http://download.openpkg.org/components/cache/liblzf/liblzf-3.6.tar.gz"
  sha256 "9c5de01f7b9ccae40c3f619d26a7abec9986c06c36d260c179cedd04b89fb46a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "14ecfe46c0eca2e896b541f8de6a6e80bb00437f6334ceaab0705812fc051a9e" => :catalina
    sha256 "f9bb64796582e2f5184779d76e3a27422b6be1326c0a220a1675e67968e392bb" => :mojave
    sha256 "e7239f7696d1e143a9ce173429766e67f3a6b30c525681d46ab4a9cff3cd0d15" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Adapted from bench.c in the liblzf source
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <string.h>
      #include <stdlib.h>
      #include "lzf.h"
      #define DSIZE 32768
      unsigned char data[DSIZE], data2[DSIZE*2], data3[DSIZE*2];
      int main()
      {
        unsigned int i, l, j;
        for (i = 0; i < DSIZE; ++i)
          data[i] = i + (rand() & 1);
        l = lzf_compress (data, DSIZE, data2, DSIZE*2);
        assert(l);
        j = lzf_decompress (data2, l, data3, DSIZE*2);
        assert (j == DSIZE);
        assert (!memcmp (data, data3, DSIZE));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llzf", "-o", "test"
    system "./test"
  end
end
