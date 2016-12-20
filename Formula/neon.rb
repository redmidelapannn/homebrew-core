class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.webdav.org/neon/neon-0.30.2.tar.gz"
  sha256 "db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ce78a66774c73e6900c87b13888ec7b41c89e9e936692f4d3b1eb187e869f165" => :sierra
    sha256 "e1cadc41a09415d36dff218707c7ebc1cd96aeedcea6ed11e93a7a4bc08869c4" => :el_capitan
    sha256 "515a0bd748567c718a283eeab0cd3d699c69a6794f7395e0c65247df8a478522" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "openssl"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
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
