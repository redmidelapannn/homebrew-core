class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.56/libsoup-2.56.0.tar.xz"
  sha256 "d8216b71de8247bc6f274ec054c08547b2e04369c1f8add713e9350c8ef81fe5"

  bottle do
    rebuild 1
    sha256 "73c55d83e42b87cc6d4131feb7a5998a0c2e9fa2006a50edc0f50a8c70ec3918" => :sierra
    sha256 "ded1c0ee228579c8cf072f24dcd92941fb284fa01d5825f1e75d9f72e1bf14d5" => :el_capitan
    sha256 "d27f74ba854b8f708a4ce71ebfe3c5a99879ff490c0b716864c5031c1db41e46" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
  depends_on "gobject-introspection"
  depends_on "vala"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-tls-check
      --enable-introspection=yes
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in",
              "VAPIDIR = @VAPIDIR@",
              "VAPIDIR = @datadir@/vala/vapi"

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
    flags = %W[
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
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
