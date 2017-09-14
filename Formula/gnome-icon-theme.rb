class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.26/adwaita-icon-theme-3.26.0.tar.xz"
  sha256 "9cad85de19313f5885497aceab0acbb3f08c60fcd5fa5610aeafff37a1d12212"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dc57e78d360039ad7a7998e3f77e8c4e88212dc22c0ba46a0ab51f8590c85e0" => :high_sierra
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :sierra
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :el_capitan
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :yosemite
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
