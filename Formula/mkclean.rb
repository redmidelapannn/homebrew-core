class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.7.tar.bz2"
  sha256 "88713065a172d1ab7fd34c8854a42f6bf8d0e794957265340328a2f692ad46d9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "53c972ef5e816bfdf8fbb77cd4bdcbb6ae8727a27729f613d52743a2126bfff4" => :sierra
    sha256 "be71f12c5045229889233f23927e43f88b4b75af86392342d8290bfb5e18d2bf" => :el_capitan
    sha256 "bc3c6e7c4b876f858e519f3df20dfc7145a4b10740db6681e2c4a7871be9b12f" => :yosemite
  end

  # Fixes compile error with Xcode-4.3+, a hardcoded /Developer.  Reported as:
  # https://sourceforge.net/p/matroska/bugs/9/
  patch :DATA if MacOS.prefer_64_bit?

  def install
    ENV.deparallelize # Otherwise there are races
    system "./configure"
    system "make", "-C", "mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install Dir["release/#{bindir}/mk*"]
  end
end

__END__
--- a/corec/tools/coremake/gcc_osx_x64.build	2011-09-25 02:25:46.000000000 -0700
+++ b/corec/tools/coremake/gcc_osx_x64.build	2012-03-15 16:27:46.000000000 -0700
@@ -4,9 +4,9 @@
 
 PLATFORMLIB = osx_x86
 SVNDIR = osx_x86
-SDK = /Developer/SDKs/MacOSX10.6.sdk
 
-CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic -mmacosx-version-min=10.6
+
+CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic
 ASMFLAGS = -f macho64 -D_MACHO
 
 #include "gcc_osx.inc"
