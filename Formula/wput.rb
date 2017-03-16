class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "https://wput.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "316b31bd737973f10e6d041e8aaa350c9831e1b63f7e9259610104bb049467d5" => :sierra
    sha256 "ef33af88fdbbab879c2c764de24e8205cf7a5ef7324713da29dd7a48308ae311" => :el_capitan
    sha256 "8145d6c51446989357cb27e313c4696a6085b0f56c6b0dc8a2ccde65479409fa" => :yosemite
  end

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/p/wput/patches/22/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/wput", "--version"
  end
end

__END__
diff --git a/src/memdbg.c b/src/memdbg.c
index 560bd7c..9e69eef 100644
--- a/src/memdbg.c
+++ b/src/memdbg.c
@@ -1,5 +1,7 @@
 #include <stdio.h>
+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <fcntl.h>
 #ifndef WIN32
 #include <sys/socket.h>
diff --git a/src/socketlib.c b/src/socketlib.c
index ab77d2b..c728ed9 100644
--- a/src/socketlib.c
+++ b/src/socketlib.c
@@ -20,7 +20,9 @@
  * It is meant to provide some library functions. The only required external depency
  * the printip function that is provided in utils.c */

+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
