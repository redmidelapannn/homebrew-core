class Pcrexx < Formula
  desc "C++ wrapper for the Perl Compatible Regular Expressions"
  homepage "https://www.daemon.de/PCRE"
  url "https://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz"
  sha256 "77ee9fc1afe142e4ba2726416239ced66c3add4295ab1e5ed37ca8a9e7bb638a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "63dd57e1a3186f3c186c3e702cfa925440e42a14f0a719dc4fd4d4aeb51ae2cf" => :sierra
    sha256 "26e7a486ad8a8c08bcdb06067b25369a8ab951ac2ec4792307c9a4b98e3850ec" => :el_capitan
    sha256 "2d5ffc99c8615e41d912c91b4db247cea4575a441d153f4eef62c2bdd3e2f2e8" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  # Fix building with libc++. Patch sent to maintainer.
  patch :DATA

  def install
    pcre = Formula["pcre"]
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pcre-lib=#{pcre.opt_lib}",
                          "--with-pcre-include=#{pcre.opt_include}"
    system "make", "install"

    # Pcre++ ships Pcre.3, which causes a conflict with pcre.3 from pcre
    # in case-insensitive file system. Rename it to pcre++.3 to avoid
    # this problem.
    mv man3/"Pcre.3", man3/"pcre++.3"
  end

  def caveats; <<-EOS.undent
    The man page has been renamed to pcre++.3 to avoid conflicts with
    pcre in case-insensitive file system.  Please use "man pcre++"
    instead.
    EOS
  end
end

__END__
diff --git a/libpcre++/pcre++.h b/libpcre++/pcre++.h
index d80b387..21869fc 100644
--- a/libpcre++/pcre++.h
+++ b/libpcre++/pcre++.h
@@ -47,11 +47,11 @@
 #include <map>
 #include <stdexcept>
 #include <iostream>
+#include <clocale>
 
 
 extern "C" {
   #include <pcre.h>
-  #include <locale.h>
 }
 
 namespace pcrepp {
