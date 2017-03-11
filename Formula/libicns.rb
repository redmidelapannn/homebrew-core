class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "https://icns.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "0c6f9fe5c62cd429263079c25ddcb7bfe256c0bb94d86434ba055a930b0fe41b" => :sierra
    sha256 "f9b7096a33a65ba0295c9fb6d78d8d7c85de18145b4fbb60f3b8edd58efdc160" => :el_capitan
    sha256 "8f799a256259b986b43c863f6b9c06c087d7a1e2f6023520516eaa92f619c7e6" => :yosemite
  end

  depends_on "jasper"
  depends_on "libpng"

  def install
    # Fix for libpng 1.5
    inreplace "icnsutils/png2icns.c",
      "png_set_gray_1_2_4_to_8",
      "png_set_expand_gray_1_2_4_to_8"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "icns.h"
      int main(void)
      {
        int    error = 0;
        FILE            *inFile = NULL;
        icns_family_t  *iconFamily = NULL;
        icns_image_t  iconImage;
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-licns", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
