class Gtksourceview < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz"
  sha256 "f5c3dda83d69c8746da78c1434585169dd8de1eecf2a6bcdda0d9925bf857c97"
  revision 4

  bottle do
    rebuild 2
    sha256 "360db3b63bbe5c1a66fbae1e89524fdd1a23ffafc608416f46c0d31cecd0c25c" => :catalina
    sha256 "978075a79d5cb52f5213174ea55736a1e6eaaa500d5e3acd567d02c6837f748b" => :mojave
    sha256 "a70b8708d7254c8baaa8f1d4f111a18b0dc9c9df9a555d2d0a0f17e112aeb6e5" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"

  # patches added the ensure that gtk-mac-integration is supported properly instead
  # of the old released called ige-mac-integration.
  # These are already integrated upstream in their gnome-2-30 branch but a release of
  # this remains highly unlikely
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gtksourceview/2.10.5.patch"
    sha256 "1c91cd534d73a0f9b0189da572296c5bd9f99e0bb0d3004a5e9cbd9f828edfaf"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksourceview.h>

      int main(int argc, char *argv[]) {
        GtkWidget *widget = gtk_source_view_new();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
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
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtksourceview-2.0
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
      -lgtksourceview-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
