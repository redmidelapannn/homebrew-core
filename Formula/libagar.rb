class Libagar < Formula
  desc "Cross-platform GUI toolkit"
  homepage "https://libagar.org/"
  url "http://stable.hypertriton.com/agar/agar-1.5.0.tar.gz"
  sha256 "82342ded342c578141984befe9318f3d376176e5f427ae3278f8985f26663c00"
  revision 1
  head "https://dev.csoft.net/agar/trunk", :using => :svn

  bottle do
    rebuild 1
    sha256 "e62cf9d00975bae4b7bcc3e74475871449f937abd78c88a29459167d7b6e35f6" => :mojave
    sha256 "184a5f2db2a8c7479e7736e92ae3d55d27c8c513c6746feb34db86d6dd878a63" => :high_sierra
    sha256 "7b11891254b29d330ba798b6695587f60855a6357f9684ae5e2dc5ef4060bbb0" => :sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "sdl"

  def install
    # Parallel builds failed to install config binaries
    # https://bugs.csoft.net/show_bug.cgi?id=223
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man}" # --mandir for configure didn't work
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <agar/core.h>
      #include <agar/gui.h>

      int main() {
        AG_Window *win;
        if (AG_InitCore("test", AG_VERBOSE) == -1 || AG_InitGraphics(NULL) == -1) {
          return 1;
        } else {
          return 0;
        }
      }
    EOS
    flags = %W[
      -I#{include}/agar
      -I#{Formula["sdl"].opt_include}/SDL
      -I#{Formula["freetype"].opt_include}/freetype2
      -I#{Formula["libpng"].opt_include}/libpng
      -L#{lib}
      -L#{Formula["sdl"].opt_lib}
      -L#{Formula["freetype"].opt_lib}
      -L#{Formula["libpng"].opt_lib}
      -L#{Formula["jpeg"].opt_lib}
      -lag_core
      -lag_gui
      -lSDLmain
      -lSDL
      -lfreetype
      -lpng16
      -ljpeg
      -Wl,-framework,Cocoa,-framework,OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
