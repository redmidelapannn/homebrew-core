class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.20/baobab-3.20.1.tar.xz"
  sha256 "e9dff12a76b0d730ce224215860512eb0188280c622faf186937563b96249d1f"

  bottle do
    sha256 "23cb2805d8f29acd8a84f3f22a2f997cf367dd57e562994dc1e12010a75e7fe2" => :el_capitan
    sha256 "b34cb607a573d398f477b6ed4cd2c09b093fa934933fb542813239b4bbaab063" => :yosemite
    sha256 "c83a230f978503ed2f4fef3416280ab7462a6af80ff8364d63ade15894f58b3a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => ["with-python", :build]
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/baobab --version")
  end
end
