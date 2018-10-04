class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://directory.fsf.org/wiki/Cadaver"
  url "https://mirrorservice.org/sites/download.salixos.org/i486/extra-14.2/source/network/cadaver/cadaver-0.23.3.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cadaver/cadaver-0.23.3.tar.gz/502ecd601e467f8b16056d2acca39a6f/cadaver-0.23.3.tar.gz"
  mirror "https://web.archive.org/web/20170629224036/www.webdav.org/cadaver/cadaver-0.23.3.tar.gz"
  sha256 "fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca"
  revision 2

  bottle do
    rebuild 1
    sha256 "9bd4e7a2c5647318ffa0eca8ca7a8af3a399f61102af78505a0e142853e10309" => :mojave
    sha256 "cb4ebd90775ad78724d172bb46cfef0cb75fac9595aff953c6802c4374085743" => :high_sierra
    sha256 "a804d64442e1808da5383082ca49dde0d122baa316f4e50f903803d8449388fe" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "neon"
  depends_on "openssl"
  depends_on "readline"

  # enable build with the latest neon
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl"].opt_prefix}",
                          "--with-neon=#{Formula["neon"].opt_prefix}"
    system "make", "-C", "lib/intl"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end

__END__
--- cadaver-0.23.3-orig/configure	2009-12-16 01:36:26.000000000 +0300
+++ cadaver-0.23.3/configure	2013-11-04 22:44:00.000000000 +0400
@@ -10328,7 +10328,7 @@
 $as_echo "$ne_cv_lib_neon" >&6; }
     if test "$ne_cv_lib_neon" = "yes"; then
        ne_cv_lib_neonver=no
-       for v in 27 28 29; do
+       for v in 27 28 29 30; do
           case $ne_libver in
           0.$v.*) ne_cv_lib_neonver=yes ;;
           esac
@@ -10975,8 +10975,8 @@
     fi
 
 else
-    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&5
-$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&6;}
+    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29 30" >&5
+$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29 30" >&6;}
     neon_got_library=no
 fi
 
