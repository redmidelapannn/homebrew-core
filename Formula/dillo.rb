class Dillo < Formula
  desc "Graphical web browser known for its speed and small footprint"
  homepage "http://www.dillo.org/"
  url "http://www.dillo.org/download/dillo-3.0.5.tar.bz2"
  sha256 "db1be16c1c5842ebe07b419aa7c6ef11a45603a75df2877f99635f4f8345148b"

  bottle do
    sha256 "56b6bcda21a8b841bc00116f03201580f164a555802e62560235234b332c95d7" => :sierra
    sha256 "be8889e4e9cf11ba62b0617ec7a43b127b057734be81eee07f5e396c1822906a" => :el_capitan
    sha256 "8a3161fc0ba590cf1b60aad9c1aec27e1d987a26e07dc7f8e0ed75d2f1423248" => :yosemite
  end

  depends_on "openssl"
  depends_on "fltk"

  # for errors about Fl_Font.H (fixed in HEAD)
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-ssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dillo", "--version"
  end
end

__END__
diff --git a/src/xembed.cc b/src/xembed.cc
index 8849449..53ea53c 100644
--- a/src/xembed.cc
+++ b/src/xembed.cc
@@ -15,11 +15,11 @@
 #define FL_INTERNALS
 #include <FL/Fl_Window.H>
 #include <FL/Fl.H>
-#include <FL/x.H>

 #include "xembed.hh"

 #ifdef X_PROTOCOL
+#include <FL/x.H>

 typedef enum {
   XEMBED_EMBEDDED_NOTIFY        = 0,

