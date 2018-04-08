class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.28/evince-3.28.0.tar.xz"
  sha256 "fa23264b65e140afb8ec27b070a277bda748d9d4a86788240d9f3514346573a8"
  revision 1

  bottle do
    rebuild 1
    sha256 "e37342d8c37d8e91e0ed81f4d258c0dbaa39b39fc5f654b5781874075c21e845" => :high_sierra
    sha256 "24372951cfc01128a7e87f6c603fe172a8e6eb27b27f6abcca331a30fda2e039" => :sierra
    sha256 "df50809a50dfc89b3bf120f83371f1eccdab2bf93de4f2a81f2fd95d4f4cd6c5" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "poppler"
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "shared-mime-info"
  depends_on "djvulibre"
  depends_on "python@2"

  def install
    # Fix build failure "ar: illegal option -- D"
    # Reported 15 Sep 2017 https://bugzilla.gnome.org/show_bug.cgi?id=787709
    inreplace "configure", "AR_FLAGS=crD", "AR_FLAGS=r"

    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--enable-djvu",
                          "--disable-browser-plugin"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
