class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.webdav.org/neon/neon-0.31.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.0.tar.gz"
  sha256 "80556f10830431476d1394c1f0af811f96109c4c4d119f0a9569b28c7526bda5"

  bottle do
    cellar :any
    sha256 "007cdf17f51e13390edd1167881247416514ba64ba7a51d5720e10c1abda51d3" => :catalina
    sha256 "e5ed2154fce4ce5131aaae3a4e4acecded58d312b37859c441ff8b3a70c9d9d3" => :mojave
    sha256 "f798a180c10ecd70437cb4b0e6292ac3a192dc87b4a5bc3c4b4c2d7b218acf5e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }

 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
