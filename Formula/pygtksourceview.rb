class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "fbbee2746a20c4d2927b339ca562449cc25e671740380006d8e8a7f3ea9814e5" => :sierra
    sha256 "69762271b9e02553eb2358db5f7c4774456ebd0088188c1b7ca25ee3eab5937b" => :el_capitan
    sha256 "f483491d6a3432ca1744f0f1eabbc0bc5ee2a4da64b9ddc3954c507856720d34" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtksourceview"
  depends_on "gtk+"
  depends_on "pygtk"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs" # attempts to download chunk.xsl on demand (and sometimes fails)
    system "make", "install"
  end

  test do
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib+"python2.7/site-packages/gtk-2.0"
    system "python", "-c", "import gtksourceview2"
  end
end
