class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.0.tar.xz"
  sha256 "ea4086b127050250c158beff28dbcdf81a797b3938bb79bbaaecc75e746fbeee"

  bottle do
    sha256 "e4749dbadcc863814431cef04ce869117b5389e34128a80e8159e9c403cf204e" => :high_sierra
    sha256 "f7b3e748b40cf5b37778adfe465005908f8117eb32bd4f7814414707c60aa4c2" => :sierra
    sha256 "4ec6fd0e798e405d9f5303dcee3ed8b622ec4609357f20858b1fa48b17e53b98" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  patch :DATA

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-gtk-doc=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/geocode-glib/meson.build b/geocode-glib/meson.build
index 8bc2bfc..55fc7ab 100644
--- a/geocode-glib/meson.build
+++ b/geocode-glib/meson.build
@@ -42,14 +42,11 @@ if libm.found()
 endif

 include = include_directories('..')
-gclib_map = join_paths(meson.current_source_dir(), 'geocode-glib.map')

 libgcglib = shared_library('geocode-glib',
                            sources,
                            dependencies: deps,
                            include_directories: include,
-                           link_depends: gclib_map,
-                           link_args: [ '-Wl,--version-script,' + gclib_map ],
                            soversion: '0',
                            version: '0.0.0',
                            install: true)

