class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.24/adwaita-icon-theme-3.24.0.tar.xz"
  sha256 "ccf79ff3bd340254737ce4d28b87f0ccee4b3358cd3cd5cd11dc7b42f41b272a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "80c8466cae3c18ac1c1e920cf86de228eb8b15f9b8b8b1a1c406029686570f7c" => :sierra
    sha256 "80c8466cae3c18ac1c1e920cf86de228eb8b15f9b8b8b1a1c406029686570f7c" => :el_capitan
    sha256 "80c8466cae3c18ac1c1e920cf86de228eb8b15f9b8b8b1a1c406029686570f7c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "librsvg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "GTK_UPDATE_ICON_CACHE=#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache"
    system "make", "install"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK+3 could probably write better tests that
    # check if GTK+3 can find the icons.
    assert (share/"icons/Adwaita/96x96/status/weather-storm-symbolic.symbolic.png").exist?
    assert (share/"icons/Adwaita/index.theme").exist?
  end
end
