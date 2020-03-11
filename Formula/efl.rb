class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.4.tar.xz"
  sha256 "454002b98922f5590048ff523237c41f93d8ab0a76174be167dea0677c879120"

  bottle do
    rebuild 1
    sha256 "2a4964447bbd940d3d9b096ace7cc2545daeb717fc695de5052b6bc9c3ab300a" => :catalina
    sha256 "fa05162936a297dad55dccf1283b13d30ff7f592dc1a555b8c90130ccdfce8a6" => :mojave
    sha256 "da18036330076d38114556c6ef966182389ba381bca5b197f0fbeb13c1f9dd6f" => :high_sierra
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
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  patch do
    url "https://github.com/Bo98/efl/commit/55970121f361faf4e55ee7d9261566d7e1a1f474.patch?full_index=1"
    sha256 "2b4d5aeca26ea08258d79195cf1202da454218a62b6c341fa117b272ca886597"
  end

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
