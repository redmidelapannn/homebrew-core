class Pygtkglext < Formula
  desc "Python bindings to OpenGL GTK+ extension"
  homepage "https://projects.gnome.org/gtkglext/download.html#pygtkglext"
  url "https://download.gnome.org/sources/pygtkglext/1.1/pygtkglext-1.1.0.tar.gz"
  sha256 "9712c04c60bf6ee7d05e0c6a6672040095c2ea803a1546af6dfde562dc0178a3"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "24d8e5ce05e8e2c939ef4be4b28e6e060740c22ce7305d7bcf0cd067565c42d5" => :sierra
    sha256 "71354c6d44dc122cc7b4553625ea8a1323f8b8d8f151a751c49d32cba898bb83" => :el_capitan
    sha256 "c795db46ea6bd9553b623fe22aaa16825649d2203b8a942bc7fd64caaa91f122" => :yosemite
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
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib+"python2.7/site-packages/gtk-2.0"
    system "python", "-c", "import pygtk", "pygtk.require('2.0')", "import gtk.gtkgl"
  end
end
