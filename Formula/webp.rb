class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.0.tar.gz"
  sha256 "5cd3bb7b623aff1f4e70bd611dc8dbabbf7688fd5eb225b32e02e09e37dfb274"

  bottle do
    cellar :any
    revision 2
    sha256 "47c2c9c22308e9cb38d4899885b52230214701c3f154452203c2cc4f18e4c15a" => :el_capitan
    sha256 "2e04b5d8053376887c50a5c26fdb8e41e99fa657e7f545f2374b5e33dbbc64b9" => :yosemite
    sha256 "8645c6806dd0ccbf22baa79575a01310ed9c4e58fc823c0828b8c7059209c5bf" => :mavericks
  end

  devel do
    url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.1-rc5.tar.gz"
    sha256 "7bd3022eefbcf34233b20570de89c1a8687acdfaa739c12e4236fc0b736339fd"
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gl",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
