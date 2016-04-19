class Devhelp < Formula
  desc "API documentation browser for GTK+ and GNOME"
  homepage "https://wiki.gnome.org/Apps/Devhelp"
  url "https://download.gnome.org/sources/devhelp/3.20/devhelp-3.20.0.tar.xz"
  sha256 "a23375c2e2b2ef6240994bc2327fcacfd42403af6d872d0cba2e16dd45ca1f1d"

  bottle do
    sha256 "b15107fce321c75d6b49aea414858975409aea992f263243674ab034228e0ba2" => :el_capitan
    sha256 "9436b744313c118745bae518746051b04946d92d3087d2ab8c2ca991fa07a46a" => :yosemite
    sha256 "6da416ba2673721d968b1a10caec69dbbd38249729942fc257246d4d9e9843e0" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "webkitgtk"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/devhelp", "--version"
  end
end
