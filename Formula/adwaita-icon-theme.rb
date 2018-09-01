class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.28/adwaita-icon-theme-3.28.0.tar.xz"
  sha256 "7aae8c1dffd6772fd1a21a3d365a0ea28b7c3988bdbbeafbf8742cda68242150"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a45802c1c75baafad106675945bd740e9b7a714e998ff7569adef3539810e78" => :mojave
    sha256 "16810b951332790a883b68f0be0a6e2198cb7a878e17a4466d5de6d7639f47ba" => :high_sierra
    sha256 "16810b951332790a883b68f0be0a6e2198cb7a878e17a4466d5de6d7639f47ba" => :sierra
    sha256 "16810b951332790a883b68f0be0a6e2198cb7a878e17a4466d5de6d7639f47ba" => :el_capitan
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
    png = "weather-storm-symbolic.symbolic.png"
    assert_predicate share/"icons/Adwaita/96x96/status/#{png}", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end
