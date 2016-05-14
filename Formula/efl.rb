class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.2.tar.gz"
  sha256 "e5699d8183c1540fe45dddaf692254632f9131335e97a09cc313e866a150b42c"
  revision 2

  bottle do
    revision 1
    sha256 "7a64857aa0980932ccbcfa209e1ce4e866d76e4dae9757a50030d03ad090e01c" => :el_capitan
    sha256 "709d645cfc6aaa2f2817f7674c1a890dd3f7bb6317ab5ad6421c1a21b67f9f5e" => :yosemite
    sha256 "0b1f0ee8700fa8ccf33a174d6604b7cd572c88e7976a889f55b7ddc5fb742c85" => :mavericks
  end

  conflicts_with "eina", :because => "efl aggregates formerly distinct libs, one of which is eina"
  conflicts_with "evas", :because => "efl aggregates formerly distinct libs, one of which is evas"
  conflicts_with "eet", :because => "efl aggregates formerly distinct libs, one of which is eet"

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "openssl"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "webp" => :optional
  depends_on "luajit"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "libtiff"
  depends_on "gstreamer"
  depends_on "gst-plugins-good"
  depends_on "dbus"
  depends_on "pulseaudio"
  depends_on "bullet"

  needs :cxx11

  def install
    ENV.cxx11
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-cocoa",
            "--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba", # There's currently (1.14) no clean profile for Mac OS, so we need to force passing configure
            "--prefix=#{prefix}",
           ]
    args << "--with-x11=none" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
