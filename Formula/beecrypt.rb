class Beecrypt < Formula
  desc "C/C++ cryptography library"
  homepage "https://beecrypt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/beecrypt/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz"
  sha256 "286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d"
  revision 6

  bottle do
    cellar :any
    rebuild 1
    sha256 "3da7dd5dde102c9f928f5295d7ca3843e1fdf42165a3103b4cadd4122c75a85e" => :sierra
    sha256 "885dd38c3216e09ab462faf92d7acaf7858a3adba0377291060fa2b89653addd" => :el_capitan
    sha256 "64bc69ef63dc52683aabb88d565ef0bc63470209cbfcc7c2bf64e02aab468ee9" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "icu4c"

  # fix build with newer clang, gcc 4.7 (https://bugs.gentoo.org/show_bug.cgi?id=413951)
  patch :p0, :DATA

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-openmp",
                          "--without-java",
                          "--without-python"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "beecrypt/base64.h"
      #include "beecrypt/sha256.h"
      #include <stdio.h>

      int main(void)
      {
        sha256Param hash;
        const byte *string = (byte *) "abc";
        byte digest[32];
        byte *crc;

        sha256Reset(&hash);
        sha256Update(&hash, string, sizeof(string) / sizeof(*string));
        sha256Process(&hash);
        sha256Digest(&hash, digest);

        printf("%s\\n", crc = b64crc(digest, 32));

        free(crc);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lbeecrypt", "-o", "test"
    assert_match /ZF8D/, shell_output("./test")
  end
end

__END__
--- include/beecrypt/c++/util/AbstractSet.h~	2009-06-17 13:05:55.000000000 +0200
+++ include/beecrypt/c++/util/AbstractSet.h	2012-06-03 17:45:55.229399461 +0200
@@ -56,7 +56,7 @@
 					if (c->size() != size())
 						return false;
 
-					return containsAll(*c);
+					return this->containsAll(*c);
 				}
 				return false;
 			}
