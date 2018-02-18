class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "https://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz"
  sha256 "ad87048adb91167b07f34974a8e53e4ec356494c29f1748de95252e8f81a5e6e"
  revision 1

  bottle do
    rebuild 1
    sha256 "dfa5364d8234802bb57a776f3e7f67529c4b0f8e2c97215fce34b8a4f002b481" => :high_sierra
    sha256 "eb0db1568a5504ac68cf73883926114294b079bf1ffbaa1ed58da4d9f303de23" => :sierra
    sha256 "de68fbb071e3af74eea5528ed75ec30a8a6c6a14839fc462c8c0b6e325570105" => :el_capitan
  end

  head do
    url "https://svn.osgeo.org/metacrs/geotiff/trunk/libgeotiff"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "proj"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-jpeg"
    system "make" # Separate steps or install fails
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "geotiffio.h"
      #include "xtiffio.h"
      #include <stdlib.h>
      #include <string.h>

      int main(int argc, char* argv[])
      {
        TIFF *tif = XTIFFOpen(argv[1], "w");
        GTIF *gtif = GTIFNew(tif);
        TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        GTIFKeySet(gtif, GeogInvFlatteningGeoKey, TYPE_DOUBLE, 1, (double)123.456);

        int i;
        char buffer[20L];

        memset(buffer,0,(size_t)20L);
        for (i=0;i<20L;i++){
          TIFFWriteScanline(tif, buffer, i, 0);
        }

        GTIFWriteKeys(gtif);
        GTIFFree(gtif);
        XTIFFClose(tif);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltiff", "-lgeotiff", "-o", "test"
    system "./test", "test.tif"
    assert_match /GeogInvFlatteningGeoKey.*123.456/, shell_output("#{bin}/listgeo test.tif")
  end
end
