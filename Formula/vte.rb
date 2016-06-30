class Vte < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://developer.gnome.org/vte/"
  url "https://download.gnome.org/sources/vte/0.28/vte-0.28.2.tar.xz"
  sha256 "86cf0b81aa023fa93ed415653d51c96767f20b2d7334c893caba71e42654b0ae"
  revision 1

  bottle do
    sha256 "9d477b873c68708c9f2b38c385f0714d843de99f04cb7b3bb8bcdcfd1c7796ac" => :el_capitan
    sha256 "2b3559219cf3adf80ee0db1cd88000b5be8299344a7a17db02db9042e3420f2b" => :yosemite
    sha256 "ab682d62021431457cb835dd87e8e3aea584d872f203731d7aad2a2f8ad310ed" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on :python

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-Bsymbolic",
      "--enable-python",
    ]

    # pygtk-codegen-2.0 has been deprecated and replaced by
    # pygobject-codegen-2.0, but the vte Makefile does not detect this.
    ENV["PYGTK_CODEGEN"] = Formula["pygobject"].bin/"pygobject-codegen-2.0"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        char *rv = vte_get_user_shell();
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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/vte-0.0
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
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lvte
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
