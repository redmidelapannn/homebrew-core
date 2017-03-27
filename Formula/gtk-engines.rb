class GtkEngines < Formula
  desc "Themes for GTK+"
  homepage "https://git.gnome.org/browse/gtk-engines/"
  url "https://download.gnome.org/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2"
  sha256 "15b680abca6c773ecb85253521fa100dd3b8549befeecc7595b10209d62d66b5"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "ed1ee68a97bd5075e7ea4dac347cca43c2da072a62f6abcfa967510ec3177493" => :sierra
    sha256 "b49dcb3e73caec0541dc8c6e5cb227c96e91266c6c65a5987ecfc87295c6e6a2" => :el_capitan
    sha256 "4dcf28a7ec6ab39fedab2f8bf1945f73f39059a4fed254ee04ac66f6de4826cd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "cairo"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to set:
      GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0
    as by default GTK looks for modules in Cellar.
    EOS
  end

  test do
    assert (pkgshare/"clearlooks.xml").exist?
    assert (lib/"gtk-2.0/2.10.0/engines/libhcengine.so").exist?
    assert (share/"themes/Industrial/gtk-2.0/gtkrc").exist?
  end
end
