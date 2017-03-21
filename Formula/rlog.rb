class Rlog < Formula
  desc "Flexible message logging facility for C++"
  homepage "https://www.arg0.net/rlog"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rlog/rlog-1.4.tar.gz"
  sha256 "a938eeedeb4d56f1343dc5561bc09ae70b24e8f70d07a6f8d4b6eed32e783f79"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5d38fbbaf616b188aabe20ced6f6922542b3018373181503aae0f91c11df3f6a" => :sierra
    sha256 "037678c083b7c2509f779f4ab1592f70249c21d1f059934946c44e50c00b8a4a" => :el_capitan
    sha256 "88f65ee687570fa010398fddfdadafade8076c297d54d53d4c1b2a15f08b9352" => :yosemite
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

# This patch solves an OSX build issue, should not be necessary for the next release according to
# https://code.google.com/p/rlog/issues/detail?id=7
__END__
--- orig/rlog/common.h.in	2008-06-14 20:10:13.000000000 -0700
+++ new/rlog/common.h.in	2009-05-18 16:05:04.000000000 -0700
@@ -52,7 +52,12 @@
 
 # define PRINTF(FMT,X) __attribute__ (( __format__ ( __printf__, FMT, X)))
 # define HAVE_PRINTF_ATTR 1
+
+#ifdef __APPLE__ 
+# define RLOG_SECTION __attribute__ (( section("__DATA, RLOG_DATA") ))
+#else
 # define RLOG_SECTION __attribute__ (( section("RLOG_DATA") ))
+#endif
 
 #if __GNUC__ >= 3
 # define expect(foo, bar) __builtin_expect((foo),bar)
