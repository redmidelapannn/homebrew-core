class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  # Canonical URL inaccessible: "http://pl.ekg2.org/ekg2-0.3.1.tar.gz"
  url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
  sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"
  revision 2

  bottle do
    rebuild 1
    sha256 "83d47d0f1a979464ae78c5c9c3cb11bec6c1f0cebc1f1d1256cb04bfac2a9cbe" => :high_sierra
    sha256 "b3aa7b8dce8a31a193e31e1037cc401b4fe6c3bedc0dbb28d281bc1437af3fa4" => :sierra
    sha256 "e4e2d486fd05370e4106f4b1b61906b20f56272fc69580f5b075942bed48394c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libgadu" => :optional
  depends_on "openssl"

  # Fix the build on OS X 10.9+
  # http://bugs.ekg2.org/issues/152
  patch :DATA

  def install
    readline = Formula["readline"].opt_prefix

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python
      --without-perl
      --with-readline=#{readline}
      --without-gtk
      --enable-unicode
    ]

    args << (build.with?("libgadu") ? "--with-libgadu" : "--without-libgadu")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ekg2", "--help"
  end
end

__END__
diff --git a/compat/strlcat.c b/compat/strlcat.c
index 6077d66..c1c1804 100644
--- a/compat/strlcat.c
+++ b/compat/strlcat.c
@@ -14,7 +14,7 @@
  *  License along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#ifndef strlcat
 #include <sys/types.h>

 size_t strlcat(char *dst, const char *src, size_t size)
@@ -39,7 +39,7 @@ size_t strlcat(char *dst, const char *src, size_t size)

	return dlen + j;
 }
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcat.h b/compat/strlcat.h
index cb91fcb..df8f4b0 100644
--- a/compat/strlcat.h
+++ b/compat/strlcat.h
@@ -1,7 +1,8 @@
+#ifndef strlcat
 #include <sys/types.h>

 size_t strlcat(char *dst, const char *src, size_t size);
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcpy.c b/compat/strlcpy.c
index 31e41bd..4a40762 100644
--- a/compat/strlcpy.c
+++ b/compat/strlcpy.c
@@ -14,7 +14,7 @@
  *  License along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#ifndef strlcpy
 #include <sys/types.h>

 size_t strlcpy(char *dst, const char *src, size_t size)
@@ -32,7 +32,7 @@ size_t strlcpy(char *dst, const char *src, size_t size)

	return i;
 }
-
+#endif
 /*
  * Local Variables:
  * mode: c
diff --git a/compat/strlcpy.h b/compat/strlcpy.h
index 1c80e20..93340af 100644
--- a/compat/strlcpy.h
+++ b/compat/strlcpy.h
@@ -1,7 +1,8 @@
+#ifndef strlcpy
 #include <sys/types.h>

 size_t strlcpy(char *dst, const char *src, size_t size);
-
+#endif
 /*
  * Local Variables:
  * mode: c
