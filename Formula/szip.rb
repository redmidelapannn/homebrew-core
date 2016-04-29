class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  url "https://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
  sha256 "a816d95d5662e8279625abdbea7d0e62157d7d1f028020b1075500bf483ed5ef"

  bottle do
    cellar :any
    revision 2
    sha256 "9c9f11b25a8d99a2fd7155e318adb5408e8e3655646c55ae79b18117a28180b0" => :el_capitan
    sha256 "1882838e825a71c59da94481a9e946f1b2c830aa8e69bd7c37e2c94d46124bd1" => :yosemite
    sha256 "05748fdf7c8288c6b4a24a56ff9f814c9c4054e8dd1216799c7c1a1d3597893d" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <stdlib.h>
      #include <stdio.h>
      #include "szlib.h"

      int main()
      {
        sz_stream c_stream;
        c_stream.options_mask = 0;
        c_stream.bits_per_pixel = 8;
        c_stream.pixels_per_block = 8;
        c_stream.pixels_per_scanline = 16;
        c_stream.image_pixels = 16;
        assert(SZ_CompressInit(&c_stream) == SZ_OK);
        assert(SZ_CompressEnd(&c_stream) == SZ_OK);
        return 0;
      }
    EOS
    system ENV.cc, "-L", lib, "test.c", "-o", "test", "-lsz"
    system "./test"
  end
end
