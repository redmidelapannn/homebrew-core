class Bsdiff < Formula
  desc "Generate and apply patches to binary files"
  homepage "https://www.daemonology.net/bsdiff"
  url "https://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz"
  sha256 "18821588b2dc5bf159aa37d3bcb7b885d85ffd1e19f23a0c57a58723fea85f48"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd9f561434db9bf964704fd21c4bededdc96dc5ff4171bad89e355a1f11d29f9" => :high_sierra
    sha256 "3c4a0decce3db274fe19d0382f8101ce2c7e1d1c7b635adb1bfe7ba03de70bbd" => :sierra
    sha256 "0cf67856129f6d864431ce423f754f5f4edd3c497c1dec8a64a534b24d772532" => :el_capitan
  end

  depends_on "bsdmake" => :build

  patch :DATA

  def install
    system "bsdmake"
    bin.install "bsdiff"
    man1.install "bsdiff.1"
  end

  test do
    (testpath/"bin1").write "\x01\x02\x03\x04"
    (testpath/"bin2").write "\x01\x02\x03\x05"

    system "#{bin}/bsdiff", "bin1", "bin2", "bindiff"
  end
end

__END__
diff --git a/bspatch.c b/bspatch.c
index 643c60b..543379c 100644
--- a/bspatch.c
+++ b/bspatch.c
@@ -28,6 +28,7 @@
 __FBSDID("$FreeBSD: src/usr.bin/bsdiff/bspatch/bspatch.c,v 1.1 2005/08/06 01:59:06 cperciva Exp $");
 #endif

+#include <sys/types.h>
 #include <bzlib.h>
 #include <stdlib.h>
 #include <stdio.h>
