class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "4302acf41dd640c2e5eb3fa521136310cfb12ab2239d2c6a8ba8d98848ddf7ae" => :high_sierra
    sha256 "a1dae615c373694bcbd289048d1c0876acec60a3b9629a2dd76382a32b676e23" => :sierra
    sha256 "e5bbd5cfcbe2445602333be20dc48fe75d8d0cd118d45d7bdb629fbf378b3cd8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "pygtk"
  depends_on "gtkglext"
  depends_on "pygobject"

  def install
    inreplace "gtk/gdkgl/gdkglext.override", "#include <GL/gl.h>", "#include <gl.h>"

    ENV["PYGTK_CODEGEN"] = "#{Formula["pygobject"].opt_bin}/pygobject-codegen-2.0"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    system "python2.7", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
