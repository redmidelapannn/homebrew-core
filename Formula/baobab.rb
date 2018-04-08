class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.28/baobab-3.28.0.tar.xz"
  sha256 "530bb269e19d1f9f562fab90377eda8ce3c3efd521e4d569f7c40e56fa3e5d63"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2873a8127ce62079d4a6b372ad7d6bda9490d3d9a0e773b1418f23ece398b14b" => :high_sierra
    sha256 "41740ea0d90d9d9d1d39668b893a552dc7346649e2356f20f2ea0a94393842f9" => :sierra
    sha256 "e6a47a5719db0bb695397583a3effb9712439ea055b7295fae5ef3dc74be6d6c" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
