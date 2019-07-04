class Libagar < Formula
  desc "Cross-platform GUI toolkit"
  homepage "http://libagar.org/"
  url "http://stable.hypertriton.com/agar/agar-1.5.0.tar.gz"
  sha256 "82342ded342c578141984befe9318f3d376176e5f427ae3278f8985f26663c00"
  revision 1
  head "https://dev.csoft.net/agar/trunk", :using => :svn

  bottle do
    rebuild 1
    sha256 "d43d1992ba880d623ee9f154e2ddfbb67a3d352d27ad1c4e3c2ce105179a14b4" => :mojave
    sha256 "6a55c19c801edf096b7491915a1054cb10d6c668bf54b735e96500d24222ab02" => :high_sierra
    sha256 "9962cfbb5b90470c8153e42dc31cdab83570d381d31fe616c581097a4ec5e4d6" => :sierra
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
