class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.8.tar.xz"
  sha256 "81c528fd1e5e03577acd80fb77798223945f043fd1d4e06920c71202eea90801"

  bottle do
    rebuild 1
    sha256 "178ec65c851f7ded8f8538de691ac1bd1fab5c8ff9b87d42a498e55cb92886c8" => :high_sierra
    sha256 "93125172572395f074894a12c5236a220119713f891c17b01694c3cbcdc93098" => :sierra
    sha256 "ddf8b1a6d211260b2fe8f5fa7116ac4646742f58960e9a340ad9bbd7c654823e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :build
  depends_on "python@2"
  depends_on "glib"
  depends_on "exiv2"

  # bug report opened on 2017/12/25, closed on 2018/01/05, reopened on 2018/02/06
  # https://bugzilla.gnome.org/show_bug.cgi?id=791941
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index 8980ac9..aa0872c 100755
--- a/configure
+++ b/configure
@@ -18635,7 +18635,7 @@ case "$target_or_host" in
 esac
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: $platform_darwin" >&5
 $as_echo "$platform_darwin" >&6; }
- if test "$platform_win32" = "yes"; then
+ if test "$platform_darwin" = "yes"; then
   PLATFORM_DARWIN_TRUE=
   PLATFORM_DARWIN_FALSE='#'
 else

