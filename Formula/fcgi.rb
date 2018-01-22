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
    sha256 "14e7a1b3d1f80883b16b95e56098dea1eacc40dd520355eac6c2e341fa0b1349" => :high_sierra
    sha256 "bbe9f94736c5eb6abd5a3864566358166b88ba74b656ccdf9c777e640656c588" => :sierra
    sha256 "4f9b91a9a6db726a57be85a873ee70533e7f8979405b48725166d3c7012c7876" => :el_capitan
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
