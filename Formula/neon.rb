class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://web.archive.org/web/20070925040920/www.webdav.org/neon/"
  url "https://mirrorservice.org/sites/distfiles.macports.org/neon/neon-0.30.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.30.2.tar.gz"
  sha256 "db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca"

  bottle do
    cellar :any
    rebuild 1
    sha256 "88a12011401baeccc9c4315d3091baa87e4d9f68206eb1a09c71f245276b72e3" => :high_sierra
    sha256 "7d0d78f3ab9552731038b01240b4a3051ca3c76dbc669b8da3003d1d7156dd9a" => :sierra
    sha256 "baabb8b74b1fe0b868cddf37574b2a5e76a6bef800d346f4cce0e0a61fddec7c" => :el_capitan
  end

  keg_only :provided_pre_mountain_lion

  depends_on "pkg-config" => :build
  depends_on "openssl"

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
                          "--with-libs=#{Formula["openssl"].opt_prefix}"
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
