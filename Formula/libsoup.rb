class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.54/libsoup-2.54.0.tar.xz"
  sha256 "fbf1038efb10d2ffbbb88bb46e7ce32b683fde8e566f36bcf26f7f69a550ec56"

  bottle do
    sha256 "c862cbc4a119f04476bde9848b54dbf2b027721ccc1f6b52e87a198adf7d32d7" => :el_capitan
    sha256 "0b036897477b9e0ee84b2572673e14eeae6db4ab1e043398beccd12dfabaed9b" => :yosemite
    sha256 "e573dea8a1d1d366e4661b5c1624c614f9912c7b44c0c5e87ce3080aebd36d7a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
  depends_on "gobject-introspection"
  depends_on "vala"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--disable-tls-check",
      "--enable-introspection=yes",
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in", "VAPIDIR = @VAPIDIR@", "VAPIDIR = @datadir@/vala/vapi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        guint version = soup_get_major_version();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
