class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://support.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  # https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz is 403
  url "ftp://ftp.hdfgroup.org/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/szip-2.1.1.tar.gz"
  sha256 "897dda94e1d4bf88c91adeaad88c07b468b18eaf2d6125c47acac57e540904a9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9aa9ce237bdfef71b3d58364ba424fd8e32da1a867337c0a981a76216610603a" => :high_sierra
    sha256 "e77c677b0cb50b398492cb506bec80ec93be63ddde0d9f6dfc71b8e52ec8989d" => :sierra
    sha256 "4e95dae6246c4081f307501cb5e3e0b4750f7c753422fc3a589dc320fc4baed6" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
