class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.28.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.28/libpng-1.6.28.tar.xz"
  sha256 "d8d3ec9de6b5db740fefac702c37ffcf96ae46cb17c18c1544635a3852f78f7a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "33ec442f7b89dcf484246a0d4478b2dd0260f95f1db21a19984444c61f3639d6" => :sierra
    sha256 "b2c805274e78f8bc70c02c6edf58873c0f9d6cca52ff98fb0787aec44c7747f6" => :el_capitan
    sha256 "0121eef8113014d9cbefa81b15fc8a2644054d9e83aba4256c6efdd6e7aa4e6e" => :yosemite
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
