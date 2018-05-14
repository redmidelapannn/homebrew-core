class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://live.gnome.org/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/2.0/goocanvas-2.0.4.tar.xz"
  sha256 "c728e2b7d4425ae81b54e1e07a3d3c8a4bd6377a63cffa43006045bceaa92e90"
  revision 1

  bottle do
    rebuild 1
    sha256 "e37256346d8d468651c0cf11cdd1a39d9adddef3ac3b6d53e83f77acedc65c5d" => :high_sierra
    sha256 "1fc0e98ed7f6f0102a00d4536588ca7f28844caf688e2ba239b63c19e9fde175" => :sierra
    sha256 "4158658fcbe5314d851b0fb7bad6e4acf70e093051b2f326708e3c0fe36d1ccc" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-gtk-doc-html"
    system "make", "install"
  end
end
