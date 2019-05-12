class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://downloads.sourceforge.net/project/slackbuildsdirectlinks/fcgi/fcgi-2.4.0.tar.gz"
  mirror "https://fossies.org/linux/www/old/fcgi-2.4.0.tar.gz"
  mirror "https://ftp.gwdg.de/pub/linux/gentoo/distfiles/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "671b0fa8992ae1aca64621dd3ac515c9f43ac8a8ab6a7dacd653829d26a8d640" => :mojave
    sha256 "26534a8d36609668a3b0b3fe01b8fb839d0ab9ecc7099977ea8c386a3658b882" => :high_sierra
    sha256 "647cb850adf0351d80636c6c83006719cd549ece6ffca5dd3526dfba20c5224f" => :sierra
  end

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # https://fastcgi-developers.fastcgi.narkive.com/Kowew8bW/patch-for-symbol-not-found-environ-on-mac-os-x
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.c").write <<~EOS
      #include "fcgi_stdio.h"
      #include <stdlib.h>
      int count = 0;
      int main(void){
        while (FCGI_Accept() >= 0){
        printf("Request number %d running on host %s", ++count, getenv("SERVER_HOSTNAME"));}}
    EOS
    system ENV.cc, "testfile.c", "-lfcgi", "-o", "testfile"
    assert_match "Request number 1 running on host", shell_output("./testfile")
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
