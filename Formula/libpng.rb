class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/libpng/libpng-1.6.34.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.34/libpng-1.6.34.tar.xz"
  sha256 "2f1e960d92ce3b3abd03d06dfec9637dfbd22febf107a536b44f7a47c60659f6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "efa57d81788f359ab4b6f95a1cd4042165caf12d41c53ab3fa67a5b0ff6d15ff" => :high_sierra
    sha256 "294cdd03d0a30fb296c4cf53f974fbb7031e61adec19c0567488b734288747cd" => :sierra
    sha256 "8a409e793c23c7c8c99b20b0a1576e7c3b8528c49d5bacbc8eaaf12c15a0444f" => :el_capitan
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
