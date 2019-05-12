class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "https://mpg321.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"

  bottle do
    rebuild 1
    sha256 "7cfdc2d686cec80b87ef4b1e049475543d87d0bc260e18415f05861ca2009de2" => :mojave
    sha256 "5c3c4187c20150b2f5323fd922645545286f787660ff8c80b834aa195b908b8f" => :high_sierra
    sha256 "52d35fa1ad73ef46547f9f2ca6dec87d627fc617fdf0ce3dd03ef6040d4d054c" => :sierra
  end

  depends_on "libao"
  depends_on "libid3tag"
  depends_on "mad"

  # 1. Apple defines semun already. Skip redefining it to fix build errors.
  #    This is a homemade patch fashioned using deduction.
  # 2. Also a couple of IPV6 values are not defined on OSX that are needed.
  #    This patch was seen in the wild for an app called lscube:
  #       lscube.org/pipermail/lscube-commits/2009-March/000500.html [LOST LINK]
  # Both patches have been reported upstream here:
  # https://sourceforge.net/p/mpg321/patches/20/
  # Remove these at: Unknown.  These have not been merged as of 0.3.2.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-mpg123-symlink",
                          "--enable-ipv6",
                          "--disable-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/mpg321", "--version"
  end
end

__END__
--- a/mpg321.h	2012-03-25 05:27:49.000000000 -0700
+++ b/mpg321.h	2012-11-15 20:54:28.000000000 -0800
@@ -290,7 +290,7 @@
 /* Shared total decoded frames */
 decoded_frames *Decoded_Frames;
 
-#if defined(__GNU_LIBRARY__) && !defined(_SEM_SEMUN_UNDEFINED)
+#if defined(__GNU_LIBRARY__) && !defined(_SEM_SEMUN_UNDEFINED) || defined(__APPLE__)
 /* */
 #else
 union semun {
--- a/network.c	2012-03-25 05:27:49.000000000 -0700
+++ b/network.c	2012-11-15 20:58:02.000000000 -0800
@@ -50,6 +50,13 @@
 
 #define IFVERB if(options.opt & MPG321_VERBOSE_PLAY)
 
+/* The following defines are needed to emulate the Linux interface on
+ * BSD-based systems like FreeBSD and OS X */
+#if !defined(IPV6_ADD_MEMBERSHIP) && defined(IPV6_JOIN_GROUP)
+#define IPV6_ADD_MEMBERSHIP IPV6_JOIN_GROUP
+#define IPV6_DROP_MEMBERSHIP IPV6_LEAVE_GROUP
+#endif
+
 int proxy_enable = 0;
 char *proxy_server;
 int auth_enable = 0;
