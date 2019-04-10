class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.1.tar.xz"
  sha256 "5baa6ab76a76c9fc567e4c32c3af2cd1d1784934c255bc5a62c512e6af6bde1c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d7c604e5cf458f450372e9195b085034575ba24a9011d9496129977f13294ea4" => :mojave
    sha256 "e953bfc1363edcd1ccb394822588aec2cb3989f10f8642e6c6473b384bafe38d" => :high_sierra
    sha256 "535bd211f8922dd4861d57a556f063936586477212e501e48efbc915b21c8d0f" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  # submitted upstream as https://gitlab.gnome.org/GNOME/geocode-glib/merge_requests/7
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-installed-tests=false", "-Denable-gtk-doc=false", ".."
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
index 8bc2bfc..b48ec62 100644
--- a/geocode-glib/meson.build
+++ b/geocode-glib/meson.build
@@ -43,15 +43,32 @@ endif

 include = include_directories('..')
 gclib_map = join_paths(meson.current_source_dir(), 'geocode-glib.map')
+link_depends = []
+link_args = []
+
+if cc.has_link_argument('-Wl,--version-script,' + gclib_map)
+	link_depends += gclib_map
+	link_args += ['-Wl,--version-script,' + gclib_map]
+endif
+
+version = '0.0.0'
+version_arr = version.split('.')
+major_version = version_arr[0].to_int()
+minor_version = version_arr[1].to_int()
+micro_version = version_arr[2].to_int()
+current = major_version + minor_version + 1
+interface_age = micro_version
+darwin_versions = [current, '@0@.@1@'.format(current, interface_age)]

 libgcglib = shared_library('geocode-glib',
                            sources,
                            dependencies: deps,
                            include_directories: include,
-                           link_depends: gclib_map,
-                           link_args: [ '-Wl,--version-script,' + gclib_map ],
+                           link_depends: link_depends,
+                           link_args: link_args,
                            soversion: '0',
                            version: '0.0.0',
+                           darwin_versions: darwin_versions,
                            install: true)

 install_headers(headers, subdir: header_subdir)
diff --git a/meson.build b/meson.build
index 0873c6c..78e5079 100644
--- a/meson.build
+++ b/meson.build
@@ -1,4 +1,4 @@
-project('geocode-glib', 'c', version: '3.26.1')
+project('geocode-glib', 'c', version: '3.26.1', meson_version : '>= 0.48.0')

 gclib_version = meson.project_version() # set in project() below
 ver_arr = gclib_version.split('.')
