class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.12/libgphoto2-2.5.12.tar.bz2"
  sha256 "b9bb28990fde45ac385e4851a07dbad2e1250404b535b0a3a3b898bb431e4e2e"

  bottle do
    rebuild 1
    sha256 "49007fb3aacdcf7ea8ae8a25f80f359fa4d8fce21b484202350e263378ce3fa2" => :sierra
    sha256 "80ba6e5b26d9002b6dad493ba24be7833c6947f78da1cbaacfe9d60516a100c6" => :el_capitan
    sha256 "4585c209fa4ec1eacd216615a7296382bd710237a04d57f635217716cee11b82" => :yosemite
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"
  depends_on "gd"
  depends_on "libexif" => :optional

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    EOS
    system ENV.cc, "test.c", "-lgphoto2", "-o", "test"
    system "./test"
  end
end
