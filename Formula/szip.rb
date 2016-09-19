class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://support.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  url "https://support.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
  sha256 "a816d95d5662e8279625abdbea7d0e62157d7d1f028020b1075500bf483ed5ef"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8b91311d23519ff860dcaca4c8bc5404b53a1eb5c1109744692e1b6c94d39236" => :sierra
    sha256 "49e7ff4046e656d04021865a82c16a291f2ea246138c9e5d97e517e974653712" => :el_capitan
    sha256 "efa13dd9c03b5b6b5071369c24603be1104a416c96f4fb9ee1b3d9dd81050225" => :yosemite
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
