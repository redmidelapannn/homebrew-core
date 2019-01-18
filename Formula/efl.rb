class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.21.0.tar.xz"
  sha256 "7e65be78a537aa67e447b945f01f4ecf9ddfa14d509bf6bbf53a60253ecbae4b"
  revision 2

  bottle do
    sha256 "ae850a8a24d756d3c5dd298b1d72421eca78ff85c51fd8d8fc5778104ac97b10" => :mojave
    sha256 "90804ee847dea43de62baec02dbd450ece790d4b5b72f0495dad24dbd5c99e14" => :high_sierra
    sha256 "26b96e52a9012b720061608eb0be6bf330ac3d607c2a8149d89c38cdd53c9809" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "bullet"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "openssl"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
