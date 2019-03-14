class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.32/at-spi2-core-2.32.0.tar.xz"
  sha256 "43a435d213f8d4b55e8ac83a46ae976948dc511bb4a515b69637cb36cf0e7220"

  bottle do
    sha256 "6ceb0a94ec180e3cee51fb957100568575b515dd7c72239d514332b232d795b4" => :mojave
    sha256 "12f5fc49d9f4020ce23144b3d8d8304c6527876c159969599416b717cfe8e5ee" => :high_sierra
    sha256 "84a74197d034fae122bcb9fa61cbd2a65a5d09c1c40968257f3e584cc1c1e743" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
