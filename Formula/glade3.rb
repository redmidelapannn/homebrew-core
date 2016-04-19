class Glade3 < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.20/glade-3.20.0.tar.xz"
  sha256 "82d96dca5dec40ee34e2f41d49c13b4ea50da8f32a3a49ca2da802ff14dc18fe"

  bottle do
    sha256 "4013056f2ea397be5517c76d63c5608a37b62a13330677e929b1584e0e76cf4a" => :el_capitan
    sha256 "5c82d6b06dd23f85b7f473776c954f430873d07ca0e4046b6795b1dba6bbb3db" => :yosemite
    sha256 "8fd46a8c6e8acd94f48d7e227e3bbe3a726b0ebe45e48505a1bc98fd1f26fa86" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gnome-common" => :build
  depends_on "yelp-tools" => :build
  depends_on "gettext"
  depends_on "libxml2" => "with-python"
  depends_on "hicolor-icon-theme"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "pygobject3"

  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "autoreconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # executable test (GUI)
    system "#{bin}/glade-3", "--version"
  end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index 4b37f94..fbfe7b4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -10,7 +10,8 @@ glade_CPPFLAGS = \
 	$(GTK_CFLAGS)      \
 	$(GTK_MAC_CFLAGS)  \
 	$(WARN_CFLAGS)     \
-	$(AM_CPPFLAGS)
+	$(AM_CPPFLAGS)     \
+	-xobjective-c
 
 glade_CFLAGS =           \
 	$(GMODULE_EXPORT_CFLAGS) \

