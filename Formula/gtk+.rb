class Gtkx < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.31.tar.xz"
    sha256 "68c1922732c7efc08df4656a5366dcc3afdc8791513400dac276009b40954658"
  end

  bottle do
    rebuild 1
    sha256 "81137408960343609d16dd0a807ddab57d4e119c2727c54e4370cf27cb9f8db6" => :sierra
    sha256 "8b880dc3922c0bf168d8c225a7b4450e5c9d034999e4943fa653e359b26a64fd" => :el_capitan
    sha256 "6b43a6ec2c54bd1b2972f7fe6aec9fc8983a6bfcf0be92e4b977f94a3cf1defc" => :yosemite
  end

  head do
    url "https://git.gnome.org/browse/gtk+.git", :branch => "gtk-2-24"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "hicolor-icon-theme"

  # Patch to allow Eiffel Studio to run in Cocoa / non-X11 mode, as well as Freeciv's freeciv-gtk2 client
  # See:
  # - https://bugzilla.gnome.org/show_bug.cgi?id=757187
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  patch do
    url "https://bug757187.bugzilla-attachments.gnome.org/attachment.cgi?id=331173"
    sha256 "ce5adf1a019ac7ed2a999efb65cfadeae50f5de8663638c7f765f8764aa7d931"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--with-gdktarget=quartz",
            "--disable-visibility"]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
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
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
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
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
