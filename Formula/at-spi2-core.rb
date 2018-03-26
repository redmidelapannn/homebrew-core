class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.26/at-spi2-core-2.26.2.tar.xz"
  sha256 "c80e0cdf5e3d713400315b63c7deffa561032a6c37289211d8afcfaa267c2615"
  revision 1

  bottle do
    rebuild 1
    sha256 "c3b51b2a8ec80e5e52ce63f92cd06c496f3b8bd7930f239b9326802aeb73485f" => :high_sierra
    sha256 "703aba00f3dafb1db584374816f15944ee63822880eb3113e7822b76c80078f0" => :sierra
    sha256 "332b73b80f874a24732570852843a0f64da1371711e4671851811d54bec695b2" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
