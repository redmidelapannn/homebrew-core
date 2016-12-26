class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksw/ohcount"
  url "https://github.com/blackducksw/ohcount.git",
      :revision => "d54514399013f2f9566baf40edd0e801b27fe17b"
  version "3.0.0-g331"
  head "https://github.com/blackducksw/ohcount.git"

  bottle do
    cellar :any
    sha256 "215c96631c2875114be6a6a78d65d8f13c1454e75fc20c8dd5666bbb61a208f9" => :sierra
    sha256 "0aab85371f7a08d8022ca9f609c912f275fe4d876e12c377d4eb0cc7a16aeb6f" => :el_capitan
    sha256 "759b20bf0138d204a3cdf33f791850d0271945b209294f8dbd7f0a301b9894a0" => :yosemite
  end

  depends_on "libmagic"
  depends_on "ragel"
  depends_on "pcre"

  patch :DATA

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    path = testpath/"test.rb"
    path.write "# comment\n puts\n puts\n"
    stats = `#{bin}/ohcount -i #{path}`.split("\n")[-1]
    assert_equal 0, $?.exitstatus
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end

__END__
--- a/build
+++ b/build
@@ -29,7 +29,7 @@ else
   INC_DIR=/opt/local/include
   LIB_DIR=/opt/local/lib
   # You shouldn't have to change the following.
-  CFLAGS="-fno-common -g"
+  #CFLAGS="-fno-common -g"
   WARN="-Wall -Wno-parentheses"
   SHARED="-dynamiclib -L$LIB_DIR -lpcre"
   SHARED_NAME=libohcount.dylib
@@ -38,7 +38,7 @@ else
 fi
 
 # C compiler and flags
-cc="gcc -fPIC -g $CFLAGS $WARN -I$INC_DIR -L$LIB_DIR"
+cc="$CC $CFLAGS -O0 $WARN $CPPFLAGS $LDFLAGS"
 
 # Ohcount source files
 files="src/sourcefile.c \
