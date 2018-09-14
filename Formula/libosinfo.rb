class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.2.0.tar.gz"
  sha256 "ee254fcf3f92447787a87b3f6df190c694a787de46348c45101e8dc7b29b5a78"

  bottle do
    rebuild 1
    sha256 "29d7e862314ee920f289d03a95b4300999aa6cee5fe6683ef80b763a03c28e6d" => :mojave
    sha256 "e6b4bad64c5c3bd10393478a248bbb7ce4d3e12bbff23393cbb405381c4776fa" => :high_sierra
    sha256 "29b243b528a0c186a5bda4bfbf40503271fc05e27b0d07f378d5dd13b78ab461" => :sierra
    sha256 "082b71dd982e8d3fad7128f4ab87e7915c8e7290a1c68f67463ce4d795f1ec9a" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  def install
    # avoid wget dependency
    inreplace "Makefile.in", "wget -q -O", "curl -o"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-silent-rules
      --disable-udev
      --disable-vala
      --enable-introspection
      --enable-tests
    ]

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
