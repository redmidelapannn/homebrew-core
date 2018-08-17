class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://zbar.sourceforge.io"

  stable do
    url "https://www.linuxtv.org/downloads/zbar/zbar-0.20.1.tar.bz2"
    sha256 "a0081a9b473d9e44e029d948a8d7f22deb1bf128980f3fc4e185298066e62a6c"
  end

  bottle do
    cellar :any
    sha256 "365c823be38fe8fce37a07e9bff7bccfb0924e6a8cc17de37c43db33df0f4a53" => :high_sierra
    sha256 "f1ddaa01a1d262e1c1f80a454e53b551bb6b5d416d4213c71e73c0d8635bb955" => :sierra
    sha256 "13fdc25d244992039f1921b4792abf6142c4b700c64296278b9919264350a8e5" => :el_capitan
  end

  head do
    url "https://git.linuxtv.org/zbar.git"
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  depends_on :x11 => :optional
  depends_on "jpeg"
  depends_on "graphicsmagick"
  depends_on "ufraw"
  depends_on "xz"
  depends_on "freetype"
  depends_on "libtool"

  def install
    gettext = Formula["gettext"]
    system "autoreconf", "-fvi", "-I", "#{gettext.opt_share}/aclocal"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python2
      --without-qt
      --disable-video
      --without-gtk
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
