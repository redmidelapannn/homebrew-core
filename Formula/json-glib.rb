class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://live.gnome.org/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.0.tar.xz"
  sha256 "99d6dfbe49c08fd7529f1fe8dcb1893b810a1bb222f1e7b65f41507658b8a7d3"

  bottle do
    sha256 "304954a41d6c9f7be0065aba0f0a4e353a7efb74cbf9362ffcae5268ee577610" => :el_capitan
    sha256 "e645d6f114ef401d5084f4ba08ec3852f2f74af960eadfcc122ccd8a62012cd2" => :yosemite
    sha256 "6b157806ad2a6058482d52f64ec98fe583972698bff685f26c436de0d57ac89c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
