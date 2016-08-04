class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.2.tar.gz"
  sha256 "e5699d8183c1540fe45dddaf692254632f9131335e97a09cc313e866a150b42c"
  revision 2

  bottle do
    revision 1
    sha256 "7e4237fc13ba20e97bd3a53be369be7f39a637f05f77193a1038ab1c95c4ebfa" => :el_capitan
    sha256 "4a1d486d967b1b2b875ddfc930cb2f08ea4935b18144ea44728cf034cd478837" => :yosemite
    sha256 "7734823ad052ba86b1f5b576a8a33bd975fd83bbc205659e60b5d288052713c9" => :mavericks
  end

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
            "--prefix=#{prefix}"]
    args << "--with-x11=none" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
