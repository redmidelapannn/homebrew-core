class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.20/gnome-themes-standard-3.20.tar.xz"
  sha256 "1cde84b34da310e6f2d403bfdbe9abb0798e5f07a1d1b4fde82af8e97edd3bdc"

  bottle do
    cellar :any
    sha256 "cab185a61b4188e6e42cf90d5aae279a75c382bd715b14b5cbb0080dc04b247d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk3-engine"

    system "make", "install"
  end

  test do
    assert (share/"icons/HighContrast/scalable/actions/document-open-recent.svg").exist?
    assert (lib/"gtk-2.0/2.10.0/engines/libadwaita.so").exist?
  end
end
