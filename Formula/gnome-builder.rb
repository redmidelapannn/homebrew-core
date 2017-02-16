class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.22/gnome-builder-3.22.4.tar.xz"
  sha256 "d569446a83ab88872c265f238f8f42b5928a6b3eebb22fd1db3dbc0dd9128795"
  revision 2

  bottle do
    sha256 "85103d740753ea4b1bb67866ff3e8dfb9797023a7b2853a8d4e6556082f26e66" => :sierra
    sha256 "8b3920f0bc42a980ca960189499026325fa75a21c80d622d40670ab3b08e56df" => :el_capitan
    sha256 "e8da389d4e806b6ce3e03b39ffc7a86a7c0afecde9200a083f1190c6f118ba5b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "mm-common" => :build
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "json-glib"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "devhelp" => :recommended
  depends_on "ctags" => :recommended
  depends_on "meson" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-builder --version")
  end
end
