class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.18/libpeas-1.18.0.tar.xz"
  sha256 "bf49842c64c36925bbc41d954de490b6ff7faa29b45f6fd9e91ddcc779165e26"

  bottle do
    sha256 "a1ea81de7d6bf8bc49339fe93ecc34a8df6f786078031e25a4161deee3b18558" => :el_capitan
    sha256 "6d7d6d45f9eee67666ddfaf7d9c950ba66b7cfc2265cc03f3691f7982c3e4b88" => :yosemite
    sha256 "5dcae22cd33d24513c1db10a82409d9febfb8c124501e7ba22d8bfd1ae50f4fc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gnome-common" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gtk"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -lpeas-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
