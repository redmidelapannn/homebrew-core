class Libagar < Formula
  desc "Cross-platform GUI toolkit"
  homepage "http://libagar.org/"
  url "http://stable.hypertriton.com/agar/agar-1.5.0.tar.gz"
  sha256 "82342ded342c578141984befe9318f3d376176e5f427ae3278f8985f26663c00"
  revision 1
  head "https://dev.csoft.net/agar/trunk", :using => :svn

  bottle do
    rebuild 1
    sha256 "35ad0c4416fac40f3db60169c0e162002e0a259039cd9a14f3f3c7203190680d" => :mojave
    sha256 "d79ae95f1a656900d4cb1e07a0194b609865d0f76869787aa0f499f0d621141f" => :high_sierra
    sha256 "6460674fedd98508375941a5c21e4b3258b322de1b5a5fb32ba20d4e5b3c6047" => :sierra
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
