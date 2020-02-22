class Liblzf < Formula
  desc "Very small, very fast data compression library"
  homepage "http://oldhome.schmorp.de/marc/liblzf.html"
  url "http://dist.schmorp.de/liblzf/liblzf-3.6.tar.gz"
  mirror "http://download.openpkg.org/components/cache/liblzf/liblzf-3.6.tar.gz"
  sha256 "9c5de01f7b9ccae40c3f619d26a7abec9986c06c36d260c179cedd04b89fb46a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9269f501f5c78a97e46ba1889ffb72c12a146ea0b1d3dc24fe74711b0e82f922" => :catalina
    sha256 "1cd8151638181036fc0b73e8cb55f9b15a20eb7d9e63ac21f8faf30c6b9f8f12" => :mojave
    sha256 "f65bc6419dbac39268947aec448ad9a3fb8261f7b5eb2443ac8b0b794568d9f1" => :high_sierra
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
