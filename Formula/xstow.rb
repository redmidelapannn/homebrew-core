class Xstow < Formula
  desc "Extended replacement for GNU Stow"
  homepage "http://xstow.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xstow/xstow-1.0.2.tar.bz2"
  sha256 "6f041f19a5d71667f6a9436d56f5a50646b6b8c055ef5ae0813dcecb35a3c6ef"

  bottle do
    rebuild 1
    sha256 "65769dbfbfe59f4ea182631cad649cb720e56ca6d2d0ee662d077e08b4e7c1b8" => :sierra
    sha256 "1c5094391ff4f588bf281bccf00057a67ceee3db49fceba417621c90bc5d9384" => :el_capitan
    sha256 "2f8d03d0853404c2b8fd7315ead45ad27780aefca1829220c74d379daa959890" => :yosemite
  end

  # Patches to allow clang to compile
  # Patches from: https://svnweb.freebsd.org/ports?view=revision&revision=319588
  # Upstream bug report: https://sourceforge.net/p/xstow/bugs/7/
  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xstow", "-Version"
  end
end

__END__
diff -u src/string_utils.h~ src/string_utils.h
--- src/string_utils.h~	2013-06-01 23:10:50.000000000 +0300
+++ src/string_utils.h	2013-06-01 22:56:43.000000000 +0300
@@ -28,6 +28,9 @@
 #  define STRSTREAM
 #endif  
 
+typedef std::vector<std::string> vec_string;
+std::ostream& operator<<( std::ostream& out, const vec_string &v );
+
 std::string toupper( std::string s );
 std::string strip( const std::string& str, const std::string& what = " \t\n\0" );
 bool is_int( const std::string &s );
diff -u src/leoini.h~ src/leoini.h
--- src/leoini.h~	2013-06-01 22:28:45.000000000 +0300
+++ src/leoini.h	2013-06-01 22:32:05.000000000 +0300
@@ -260,11 +260,9 @@
 
     if( start == std::string::npos ||
 	end == std::string::npos )
-      s = "";
-    else
-      s = s.substr( start+1, start-end -1 );
+      return s2x<A>("");
 
-    return s2x<A>(s);
+    return s2x<A>(s.substr( start+1, start-end -1 ));
   }
 } // namespace Leo
 
