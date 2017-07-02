class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # The original homepage currently has no content: http://www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://downloads.sourceforge.net/project/slackbuildsdirectlinks/fcgi/fcgi-2.4.0.tar.gz"
  mirror "https://fossies.org/linux/www/old/fcgi-2.4.0.tar.gz"
  mirror "https://ftp.gwdg.de/pub/linux/gentoo/distfiles/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0046701d868c60d426de04b7c00367d4d485e3c01ec7701def2060c4de7babe5" => :sierra
    sha256 "0bb71aac5dac99e20b83fa6f4b42e60c29f396e182990bb64e331b455bee109a" => :el_capitan
    sha256 "02b4e2634ed82df12ff02010f6dff716a2f2dcd477543b37544e0c0353bb981e" => :yosemite
  end

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # http://mailman.fastcgi.com/pipermail/fastcgi-developers/2009-January/000152.html
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
--- a/libfcgi/fcgi_stdio.c
+++ b/libfcgi/fcgi_stdio.c
@@ -40,7 +40,12 @@

 #ifndef _WIN32

+#if defined(__APPLE__)
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#else
 extern char **environ;
+#endif

 #ifdef HAVE_FILENO_PROTO
 #include <stdio.h>
