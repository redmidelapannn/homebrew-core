class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.24/gnome-builder-3.24.2.tar.xz"
  sha256 "84843a9f4af2e1ee1ebfac44441a2affa2d409df9066e7d11bf1d232ae0c535a"
  revision 7

  bottle do
    sha256 "574d9889f284d1d135ac18d99dcd4cbf38da0db8f1e91e6b7285a7974f57f2ed" => :high_sierra
    sha256 "0c08572522d75c37d2b5e7ac21564263fcbf42b723fef05c2967725322a5a88b" => :sierra
    sha256 "d0148685dabbb0763926c9742293bc4dcfed9a814a05a09e9dbfb23ad32c7c91" => :el_capitan
  end

  deprecated_option "with-python3" => "with-python"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "coreutils" => :build
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "gspell"
  depends_on "enchant"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "ctags" => :recommended
  depends_on "meson" => :recommended
  depends_on "python" => :optional
  depends_on "pygobject3" if build.with? "python"

  needs :cxx11

  def install
    # Bugreport opened at https://bugzilla.gnome.org/show_bug.cgi?id=780293
    ENV.append "LIBS", `pkg-config --libs enchant`.chomp
    inreplace "doc/Makefile.in", "cp -R", "gcp -R"

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
