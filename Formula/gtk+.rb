class Gtkx < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  revision 1

  stable do
    url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.32.tar.xz"
    sha256 "b6c8a93ddda5eabe3bfee1eb39636c9a03d2a56c7b62828b359bf197943c582e"
  end

  bottle do
    rebuild 1
    sha256 "1990921cbdaa8e9cd0b3e8ef25b3dd722c1103b7f3f16551860a28c74c980842" => :high_sierra
    sha256 "15fec0a1875f3df5d99836a42733394824c962b969680a5006acf68e680a126a" => :sierra
    sha256 "954044d1b4cdfbcaf408440f8f902753c3bb9de74b1652ae4dee2359e2bc77b0" => :el_capitan
  end

  head do
    url "https://git.gnome.org/browse/gtk+.git", :branch => "gtk-2-24"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

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

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"

    inreplace bin/"gtk-builder-convert", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
