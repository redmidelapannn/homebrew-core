class Fbida < Formula
  desc "View and edit photo images"
  homepage "https://linux.bytesex.org/fbida/"
  url "https://dl.bytesex.org/releases/fbida/fbida-2.10.tar.gz"
  sha256 "7a5a3aac61b40a6a2bbf716d270a46e2f8e8d5c97e314e927d41398a4d0b6cb6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2cddc03d4f1dbcaabe0f681d1385e9309259b89088f7e7c82c4a56be63b82e4b" => :sierra
    sha256 "03f5660103d2ab61ad621526a75dbb5b60c987937db0f81019dbab85fa7d8c72" => :el_capitan
    sha256 "73051a78942a31dd33073ede94a34278dd72b66be9c73931c901ee6455f4d36f" => :yosemite
  end

  depends_on "libexif"
  depends_on "jpeg"

  # Fix issue in detection of jpeg library
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "make"
    bin.install "exiftran"
    man1.install "exiftran.man" => "exiftran.1"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end

__END__
diff --git a/GNUmakefile b/GNUmakefile
index 2d18ab4..5b409fb 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -30,7 +30,7 @@ include $(srcdir)/mk/Autoconf.mk
 
 ac_jpeg_ver = $(shell \
 	$(call ac_init,for libjpeg version);\
-	$(call ac_s_cmd,echo JPEG_LIB_VERSION \
+	$(call ac_s_cmd,printf JPEG_LIB_VERSION \
		| cpp -include jpeglib.h | tail -n 1);\
 	$(call ac_fini))
 
