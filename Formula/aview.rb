class Aview < Formula
  desc "ASCII-art image browser and animation viewer"
  homepage "https://aa-project.sourceforge.io/"
  url "https://downloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz"
  sha256 "42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ae7e727f41c84ca26fd18d70f5b2ecc12666dec0a704fc48a98fdfff35f52c0e" => :sierra
    sha256 "155f0b87f7fb9574ee525b5506fd85ab35d00e0996f05fbfb49a5460d72f96fa" => :el_capitan
    sha256 "827ac053207196c9533da9ed22d73c58e45e61fa10531c6d6f372c8f37802419" => :yosemite
  end

  depends_on "aalib"

  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/image.c b/image.c
index 232b838..9780e61 100644
--- a/image.c
+++ b/image.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <unistd.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 
 int imgwidth, imgheight;
diff --git a/ui.c b/ui.c
index d316f7a..134a4ca 100644
--- a/ui.c
+++ b/ui.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <ctype.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <aalib.h>
 #include "shrink.h"

