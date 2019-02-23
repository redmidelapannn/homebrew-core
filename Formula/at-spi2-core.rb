class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.31/at-spi2-core-2.31.2.tar.xz"
  sha256 "ee886d3fc52def853f73bc63e517b00c8572998419aa64788181a9a1a43cfcdb"

  bottle do
    sha256 "86838dbdea778a754470fa758959b733120b1b5ae019a4089cc9cd360e50133e" => :mojave
    sha256 "84f2a088840602462c68c2a33208cbe4671f62b22fa7371ebd18a087351deca6" => :high_sierra
    sha256 "e24de28ba8fa3221e48669b6a449a1aacc430fba22b8ea7461f0bbaf02bb1d4b" => :sierra
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
