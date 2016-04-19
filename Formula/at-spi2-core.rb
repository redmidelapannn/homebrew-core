class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.20/at-spi2-core-2.20.1.tar.xz"
  sha256 "6ed858e781f5aa9a9662b3beb5ef82f733dac040afc8255d85dffd2097f16900"

  bottle do
    sha256 "8990136d46ca6e97cad7bd8e679c75b4fe5678a63fefee056511d9e78004bdf6" => :el_capitan
    sha256 "8ccfce235688b73eba3f0b2a19bc772e864f3a461b7b894f98ff63c744ccfa29" => :yosemite
    sha256 "defb6b2424dc1b26926435a5102631d2f3fd34103a3a1b9f52cd0645d1455e94" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "d-bus"
  depends_on :x11
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
