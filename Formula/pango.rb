class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.40/pango-1.40.6.tar.xz"
  sha256 "ca152b7383a1e9f7fd74ae96023dc6770dc5043414793bfe768ff06b6759e573"

  bottle do
    rebuild 1
    sha256 "fa547dc6a2ef0b1ee12771373043f10c8974757887c1adccad185893c4b47bda" => :sierra
    sha256 "3bf046b894e6a87a2a95f191ef87e1bd051f0f8914380439a847cac17b964af8" => :el_capitan
    sha256 "ba1ed4bb1b751e4ac8f29da9167bbb622340048e39c604a5089a041727e7a0cb" => :yosemite
  end

  head do
    url "https://git.gnome.org/browse/pango.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "glib"
  depends_on "cairo"
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "gobject-introspection"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --enable-introspection=yes
      --enable-static
    ]

    if build.with? "x11"
      args << "--with-xft"
    else
      args << "--without-xft"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<-EOS.undent
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
