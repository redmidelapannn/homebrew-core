class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/2.1/gtk-mac-integration-2.1.2.tar.xz"
    sha256 "68e682a3ba952e7d4b1cfa2c7147c5fcd76f8bd9792a567e175a619af5954af1"

    patch do
      url "https://github.com/jralls/gtk-mac-integration/pull/11.patch?full_index=1"
      sha256 "4523207ea652b9048d01a58c05369c871def4e187db267ab7bad85ae1e102c31"
    end

    patch do
      url "https://github.com/jralls/gtk-mac-integration/pull/13.patch?full_index=1"
      sha256 "b0ecfb9a3c5cd9651584b33191b69915627cc9e09e78fb4623fcaa64915ee13d"
    end
  end

  bottle do
    rebuild 2
    sha256 "bc561e3e33f0dfcd822cac738fbc166f243ee261b6af2f7388cb198fb540e9e7" => :mojave
    sha256 "f60591efa6136d01a718e80a7e032b0bf280dba1a03028ff61d8c76b984dbc4c" => :high_sierra
    sha256 "25ad5d65f861cd0b6ebb6b08386cbbee12725bd4b47d564640940d78f61d03c4" => :sierra
    sha256 "3e2e7b176c6c0bd8a1827a3458cf1e7f0db2cc9c26e7fe6cc02d72986f40b91d" => :el_capitan
  end

  head do
    url "https://github.com/jralls/gtk-mac-integration.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "pygtk"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-gtk2
      --with-gtk3
      --enable-python=yes
      --enable-introspection=yes
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/gtkmacintegration
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DMAC_INTEGRATION
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmacintegration-gtk2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
