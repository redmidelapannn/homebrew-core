class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.mirrorservice.org/sites/distfiles.macports.org/neon/neon-0.30.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.30.2.tar.gz"
  sha256 "db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d78184e0231716166c3fad770285529ae86fbfd1ef1ead04b9424992e511fba" => :high_sierra
    sha256 "dc34ee68fcd74e1398f5b42fc8f79dc5c6a33e8cbef97cb7d6596464bb3a9a22" => :sierra
    sha256 "4f849ff38b92635c8066eb80c51384103f87c0dc75bf8876cfd0aa4f383739a2" => :el_capitan
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
