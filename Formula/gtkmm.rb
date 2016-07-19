class Gtkmm < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/2.24/gtkmm-2.24.4.tar.xz"
  sha256 "443a2ff3fcb42a915609f1779000390c640a6d7fd19ad8816e6161053696f5ee"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "98c29411c82104b57017715978028f23ef6e9fb1743709595b1d7e74de34bb96" => :el_capitan
    sha256 "59c1e3a604721c5ea6bcdc8a650eee02e011380277b2db2a7599e54c841dec0b" => :yosemite
    sha256 "ef089caeeaa94118a26fde478d70bb85f9be00c75a573f064e2fd11057ca8b94" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "gtk+"
  depends_on "libsigc++"
  depends_on "pangomm"
  depends_on "atkmm"
  depends_on "cairomm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gtkmm.h>

      int main(int argc, char *argv[]) {
        Gtk::Label label("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    atkmm = Formula["atkmm"]
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pangomm = Formula["pangomm"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{atkmm.opt_include}/atkmm-1.6
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.0
      -I#{cairomm.opt_lib}/cairomm-1.0/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_include}/gtk-unix-print-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/gdkmm-2.4
      -I#{include}/gtkmm-2.4
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gdkmm-2.4/include
      -I#{lib}/gtkmm-2.4/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pangomm.opt_include}/pangomm-1.4
      -I#{pangomm.opt_lib}/pangomm-1.4/include
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{atkmm.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairomm-1.0
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkmm-2.4
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmm-2.4
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
