class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"
  revision 1

  bottle do
    cellar :any
    sha256 "7b73fa4d1de66e3fd2e53cf5f91d9a8300d53530914db33f3b91c8d80d7ce183" => :el_capitan
    sha256 "08c5cbd8b4a101db901481ede63a6b21655c71dcb41c24a2ffa5c0795c4cde41" => :yosemite
    sha256 "d4cf71347cb85bfd6f8dc5b1fef94cacea60d05696836f5138a0a937c150d148" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/pygobject/patch-enum-types.diff"
    sha256 "99a39c730f9af499db88684e2898a588fdae9cd20eef70675a28c2ddb004cb19"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
  end

  test do
    system "python", "-m", "pygtk", "-c", "pygtk.require(\"2.0\")"
  end
end
