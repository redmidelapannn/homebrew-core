class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.56/gobject-introspection-1.56.0.tar.xz"
  sha256 "0d7059fad7aa5ec50d9678aea4ea139acab23737e9cf9ca0d86c615cecbaa0f8"
  revision 1

  bottle do
    rebuild 1
    sha256 "8f6b1496adcd11dae858cf66661eda96fe43b125f52f6b2efce6993bfaf3b727" => :high_sierra
    sha256 "1192d2e92a48f7714a3b260ab5abafe1e287380815f815a4d57f086a5b441562" => :sierra
    sha256 "9c13d1a430e8711f4c14e7e6282287965d1564e0e23236a8ab12486976848dba" => :el_capitan
  end

  depends_on "pkg-config"
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python@2"

  # see https://gitlab.gnome.org/GNOME/gobject-introspection/merge_requests/11
  patch :DATA

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@2"].opt_bin}/python2"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end

__END__
diff --git a/giscanner/ccompiler.py b/giscanner/ccompiler.py
index 29de0ee..8d89502 100644
--- a/giscanner/ccompiler.py
+++ b/giscanner/ccompiler.py
@@ -119,7 +119,7 @@ class CCompiler(object):
         if self.check_is_msvc():
             runtime_path_envvar = ['LIB', 'PATH']
         else:
-            runtime_path_envvar = ['LD_LIBRARY_PATH']
+            runtime_path_envvar = ['LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH']
             # Search the current directory first
             # (This flag is not supported nor needed for Visual C++)
             args.append('-L.')

