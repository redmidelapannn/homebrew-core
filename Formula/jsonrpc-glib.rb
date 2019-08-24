class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.32/jsonrpc-glib-3.32.0.tar.xz"
  sha256 "bc60aa36c8bdc9c701ad490508445633a9f3973ae0bd5bdd0633d5f6ffeea6eb"
  revision 1

  bottle do
    cellar :any
    sha256 "b6ec6ec59983d8ed826b3c751efcce06a177bc69789f92a9a05fc899f28d6aec" => :mojave
    sha256 "7a8bdc8a57df256c6eb217675e285a778c085c28ac03fc6a0434d0bd5e1153b4" => :high_sierra
    sha256 "d9ab2c99ae408f3fea2924911fdafa762fad749ca9ae40ad6a8c4bfc08e247d0" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"

  # submitted upstream as https://gitlab.gnome.org/GNOME/jsonrpc-glib/merge_requests/5
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <jsonrpc-glib.h>

      int main(int argc, char *argv[]) {
        JsonrpcInputStream *stream = jsonrpc_input_stream_new(NULL);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/jsonrpc-glib-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -ljsonrpc-glib-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/meson.build b/meson.build
index e949308..cb98d63 100644
--- a/meson.build
+++ b/meson.build
@@ -26,6 +26,8 @@ current = jsonrpc_glib_version_minor * 100 + jsonrpc_glib_version_micro - jsonrp
 revision = jsonrpc_glib_interface_age
 libversion = '@0@.@1@.@2@'.format(soversion, current, revision)

+darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, revision)]
+
 config_h = configuration_data()
 config_h.set_quoted('GETTEXT_PACKAGE', 'libjsonrpc_glib')
 config_h.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
diff --git a/src/meson.build b/src/meson.build
index 3366e96..83fe506 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -52,11 +52,12 @@ libjsonrpc_glib = library(
   'jsonrpc-glib-' + apiversion,
   libjsonrpc_glib_sources,

-        c_args: hidden_visibility_args + release_args,
-  dependencies: libjsonrpc_glib_deps,
-     soversion: soversion,
-       version: libversion,
-       install: true,
+         c_args: hidden_visibility_args + release_args,
+   dependencies: libjsonrpc_glib_deps,
+      soversion: soversion,
+        version: libversion,
+darwin_versions: darwin_versions,
+        install: true,
 )

 libjsonrpc_glib_dep = declare_dependency(
