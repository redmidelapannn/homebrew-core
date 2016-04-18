class Nload < Formula
  desc "Realtime console network usage monitor"
  homepage "http://www.roland-riegel.de/nload/"
  url "http://www.roland-riegel.de/nload/nload-0.7.4.tar.gz"
  sha256 "c1c051e7155e26243d569be5d99c744d8620e65fa8a7e05efcf84d01d9d469e5"

  bottle do
    revision 1
    sha256 "02aebe91ca7afa571e248b24572ccba8f5eda055e1b80a32674b540a6df2b97e" => :el_capitan
    sha256 "90497e35decef1b48c095d4e2232c0d185e9ac82204642d04656d27e2ae0bddf" => :yosemite
    sha256 "07f6a83911a9e5aadd9d4985d9b528f3e36bbe1174142a007d1bedb9fb7b11c8" => :mavericks
  end

  fails_with :llvm do
    build 2334
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # crash on F2 and garbage in adapter name, see https://sourceforge.net/p/nload/bugs/8/ reported on 2014-04-03
  patch :p0 do
    url "https://sourceforge.net/p/nload/bugs/_discuss/thread/c9b68d8e/4a65/attachment/devreader-bsd.cpp.patch"
    sha256 "19055158b72722f7dabff9890931094cac591bcc6de3e90a7f4744d28746ebc7"
  end

  # Patching configure.in file to make configure compile on Mac OS.
  # Patch taken from MacPorts.
  patch :DATA

  def install
    system "./run_autotools"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
  end
end


__END__
diff --git a/configure.in b/configure.in
index 87ecc88..4df8dc3 100644
--- a/configure.in
+++ b/configure.in
@@ -38,7 +38,7 @@ case $host_os in
 
         AC_CHECK_FUNCS([memset])
         ;;
-    *bsd*)
+    *darwin*)
         AC_DEFINE(HAVE_BSD, 1, [Define to 1 if your build target is BSD.])
         AM_CONDITIONAL(HAVE_BSD, true)
