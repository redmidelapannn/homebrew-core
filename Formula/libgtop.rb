class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.34/libgtop-2.34.0.tar.xz"
  sha256 "8d8ae39e700d1c8c0b3e1391ed10ca88e6fc14f49d175d516dab6e3313b4ee2a"

  bottle do
    sha256 "adc06319cc57ea8bc99ece411f0cefa85047b2096d6723ec90b2eecb1a382ccf" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <glibtop/sysinfo.h>

      int main(int argc, char *argv[]) {
        const glibtop_sysinfo *info = glibtop_get_sysinfo();
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
      -I#{include}/libgtop-2.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgtop-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
