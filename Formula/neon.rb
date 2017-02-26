class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.webdav.org/neon/neon-0.30.2.tar.gz"
  sha256 "db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e194355c01663c06cce7ffc602e1bf609c2da088f8a337828327407b6c2f926a" => :sierra
    sha256 "f8410e19ddd14b0c09a038166d9422283c383b2d1908544e2beef9844606aeb4" => :el_capitan
    sha256 "8271707a69c66599b1e926be1fd9e5656e83102e4386cc37ef98e46017596e6d" => :yosemite
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
