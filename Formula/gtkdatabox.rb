class Gtkdatabox < Formula
  desc "Widget for live display of large amounts of changing data"
  homepage "https://sourceforge.net/projects/gtkdatabox/"
  url "https://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox/0.9.3.0/gtkdatabox-0.9.3.0.tar.gz"
  sha256 "1f426b525c31a9ba8bf2b61084b7aef89eaed11f8d0b2a54bde467da16692ff2"

  bottle do
    cellar :any
    sha256 "a8bc4dfd5cb37cc5f2b92a022153e18f6e8a316ae829999663d9dfbe468529ab" => :sierra
    sha256 "999cb4ae98d293fb666ba2f6b819dd9febb9bebb8b1ef4e2dcb2ad409666a534" => :el_capitan
    sha256 "954c826eb6005ecda2916bafe1583b4c77b0db1f22dc3ca2c9c2151036320635" => :yosemite
    sha256 "9f4aca58b94eac38ad5e8b08c97c11e8942691e6010cfae57e5ebfb8fc47b82e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtkdatabox.h>

      int main(int argc, char *argv[]) {
        GtkWidget *db = gtk_databox_new();
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
      -I#{include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
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
      -lgtkdatabox
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
