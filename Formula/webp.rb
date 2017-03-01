class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz"
  sha256 "c928119229d4f8f35e20113ffb61f281eda267634a8dc2285af4b0ee27cf2b40"

  bottle do
    cellar :any
    rebuild 1
    sha256 "847a1472698c401153fe4088fee90391978a15b3152cf5454f65806a668b9ee0" => :sierra
    sha256 "d97bafdb450b595f62b095d886b92e62f0b3c9efcd725446c4cc2b182bac4648" => :el_capitan
    sha256 "1d029916341f03bb979f3251fe83a97aa4d6f619ead6dcc34414fcb97dbff0f4" => :yosemite
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
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?

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
