class Tinyscheme < Formula
  desc "Very small Scheme implementation"
  homepage "http://tinyscheme.sourceforge.net"
  url "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz"
  sha256 "eac0103494c755192b9e8f10454d9f98f2bbd4d352e046f7b253439a3f991999"

  bottle do
    sha256 "a9da6a45e87b3a48789d2a7a89336c5a7ec86c47453bbf59a910f78434fd44f2" => :el_capitan
    sha256 "29c90ebfbc60afeefc00377d0e6c086d2a467bab4a9a93953c14d90a1b299b72" => :yosemite
    sha256 "497347cb45f213b66c5e9534ee7575c9ef6b07cd72858d92f9fbbf38d3380d4f" => :mavericks
  end

  # Modify compile flags for Mac OS X per instructions
  patch :DATA

  def install
    system "make", "INITDEST=#{share}"
    lib.install("libtinyscheme.dylib")
    share.install("init.scm")
    bin.install("scheme")
  end

  test do
    (testpath/"expected.txt").write <<-EOS.undent

      ts> Hello, World!#t
      ts> 
      #t
      ts> #<EOF>
    EOS
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS
    system "echo", "A"
    assert_match "Usage: tinyscheme", shell_output("#{bin}/scheme -?", 1)
    system "echo", "B"
    `#{bin}/scheme -?`
    system "echo", "C"
    `#{bin}/scheme hello.scm`
    system "echo", "D"
    assert_equal File.read(testpath/"expected.txt").chomp, pipe_output("#{bin}/scheme -", File.read(testpath/"hello.scm"))
    system "echo", "E"
    assert_equal "Hello, World!", shell_output("#{bin}/scheme hello.scm").chomp
  end
end

__END__
--- a/makefile
+++ b/makefile
@@ -21,7 +21,7 @@
 CC = gcc -fpic -pedantic
 DEBUG=-g -Wall -Wno-char-subscripts -O
 Osuf=o
-SOsuf=so
+SOsuf=dylib
 LIBsuf=a
 EXE_EXT=
 LIBPREFIX=lib
@@ -34,7 +34,6 @@ LD = gcc
 LDFLAGS = -shared
 DEBUG=-g -Wno-char-subscripts -O
 SYS_LIBS= -ldl -lm
-PLATFORM_FEATURES= -DSUN_DL=1

 # Cygwin
 #PLATFORM_FEATURES = -DUSE_STRLWR=0
@@ -61,7 +60,7 @@ PLATFORM_FEATURES= -DSUN_DL=1
 #LIBPREFIX = lib
 #OUT = -o $@

-FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0
+FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -DOSX -DInitFile="\"$(INITDEST)/init.scm"\"

 OBJS = scheme.$(Osuf) dynload.$(Osuf)

