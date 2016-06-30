class Jdep < Formula
  desc "Analyze Java .class files and produce Makefile dependencies."
  homepage "http://www.fudco.com/software/jdep.html"
  url "http://www.fudco.com/software/jdep-1.3.tar.gz"
  sha256 "3dd925ae2523cca59e4aaa7cbb8daa28927b40520f0f8dccead91d9edea1dc65"

  patch :DATA

  def install
    system "make"
    bin.install "bin/jdep"
    bin.install "bin/touchp"
    prefix.install "example"
  end

  test do
    cp_r "#{prefix}/example", "."
    system "make", "-C", "example"
  end
end
__END__
diff --git a/jdep.c b/jdep.c
index b415cb5..15573d6 100644
--- a/jdep.c
+++ b/jdep.c
@@ -25,7 +25,7 @@
 */
 
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <strings.h>
 #include <dirent.h>

