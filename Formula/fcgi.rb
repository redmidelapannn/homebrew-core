class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # The original homepage currently has no content: http://www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://fossies.org/linux/www/old/fcgi-2.4.0.tar.gz"
  mirror "https://ftp.gwdg.de/pub/linux/gentoo/distfiles/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4e0eb6743cced7792a0f8771c97a69fd802ffa1acbaadeea1ae1e2bdc56d927c" => :sierra
    sha256 "670ed139cf2941f830fb1eb12f1a87659149e76d3ad9d6948edb8aa228cbea0e" => :el_capitan
    sha256 "2f29532f1635b6ff1a584dfe84637027ed0a7f2889542e60b9cc004b20125dd0" => :yosemite
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
