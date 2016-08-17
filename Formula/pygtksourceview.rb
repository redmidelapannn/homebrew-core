class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "c00e85e34efffffd2239d84d9f9741c8c4dad3855652e83a535ca7b6fac649f9" => :el_capitan
    sha256 "cacb794ae4aa24b99d0a3c7949c982e0e4206090b25fb85a655039111093e454" => :yosemite
    sha256 "a831bd3fac7e53ecf8e17e849d2b8f1117d2ad0d919668415f83d0b99dd9701b" => :mavericks
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
    system "python", "-c", "import gtksourceview2"
  end
end
