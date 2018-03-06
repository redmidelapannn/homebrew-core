class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "6df393a5302290616ba46a31723be8fdeb78041279e720c962b7820b5c36d440" => :high_sierra
    sha256 "acac4a283cba2dd2fb2b9dcd92897a35e9993e6fe544f946cd61e55a199f8a1b" => :sierra
    sha256 "14dabb273ddbf89761be7b973ae545255f25c603ed544f3a162e30cbf5a95a42" => :el_capitan
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
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    system "python2.7", "-c", "import gtksourceview2"
  end
end
