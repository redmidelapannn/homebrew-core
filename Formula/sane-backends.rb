class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"
    bottle do
    sha256 "10d956df65877cb9fa07690edd7c17220010545abc1ed0ff9d460ba93e5194aa" => :el_capitan
    sha256 "75f3c190d46305bc478311684b2a55b8b1a2f1de4d8179fa7e00731602491265" => :yosemite
    sha256 "ba0d06134b376371ae338893689eb1aa3b7ba166a7ee3b5df8ee1011a3ebc10d" => :mavericks
  end
    # Fixes some missing headers missing error. Reported upstream
    # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
    patch :DATA
  end

  head do
    url "https://alioth.debian.org/anonscm/git/sane/sane-backends.git"
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

  

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"

    # Some drivers require a lockfile
    (var+"lock/sane").mkpath
  end
end

__END__
diff --git a/backend/pieusb_buffer.c b/backend/pieusb_buffer.c
index 53bd867..23fc645 100644
--- a/backend/pieusb_buffer.c
+++ b/backend/pieusb_buffer.c
@@ -100,7 +100,13 @@
 #include <stdio.h>
 #include <fcntl.h>
 #include <sys/mman.h>
+
+#ifdef __APPLE__
+#include <machine/endian.h>
+#elif
 #include <endian.h>
+#endif
+
 
 /* When creating the release backend, make complains about unresolved external
  * le16toh, although it finds the include <endian.h> */
diff --git a/include/sane/sane.h b/include/sane/sane.h
index 5320b4a..736a9cd 100644
--- a/include/sane/sane.h
+++ b/include/sane/sane.h
@@ -20,6 +20,11 @@
 extern "C" {
 #endif
 
+#ifdef __APPLE__
+// Fixes u_long missing error
+#include <sys/types.h>
+#endif
+
 /*
  * SANE types and defines
  */
diff --git a/include/sane/sanei_backend.h b/include/sane/sanei_backend.h
index 1b5afe2..982dedc 100644
--- a/include/sane/sanei_backend.h
+++ b/include/sane/sanei_backend.h
@@ -96,7 +96,9 @@
 #  undef SIG_SETMASK
 # endif
 
+# ifndef __APPLE__
 # define sigset_t               int
+# endif
 # define sigemptyset(set)       do { *(set) = 0; } while (0)
 # define sigfillset(set)        do { *(set) = ~0; } while (0)
 # define sigaddset(set,signal)  do { *(set) |= sigmask (signal); } while (0)
diff --git a/sanei/sanei_ir.c b/sanei/sanei_ir.c
index 42e82ba..0db2c29 100644
--- a/sanei/sanei_ir.c
+++ b/sanei/sanei_ir.c
@@ -29,7 +29,13 @@
 
 #include <stdlib.h>
 #include <string.h>
+#ifdef __APPLE__ //OSX
+#include <sys/types.h>
+#include <limits.h>
+#include <float.h>
+#elif // not OSX
 #include <values.h>
+#endif
 #include <math.h>
 
 #define BACKEND_NAME sanei_ir  /* name of this module for debugging */
