class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.56/gobject-introspection-1.56.0.tar.xz"
  sha256 "0d7059fad7aa5ec50d9678aea4ea139acab23737e9cf9ca0d86c615cecbaa0f8"
  revision 1

  bottle do
    sha256 "5c0f6e0bf0d2cb6e687113fb86c4e69b3f11071627ba72d3ab48e9f694f55de4" => :high_sierra
    sha256 "e05e21ce6a6dbb07dffe0ce37743aa2a38119444899ae52b47eaaad0bcdca0bf" => :sierra
    sha256 "fb6397d7abb202e201f108f2573c3f874862578740a24ee4875b7ea3b7a68b65" => :el_capitan
  end

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python@2" if MacOS.version <= :mavericks

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

    python = if MacOS.version >= :yosemite
      "/usr/bin/python2.7"
    else
      Formula["python@2"].opt_bin/"python2.7"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=#{python}"
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

