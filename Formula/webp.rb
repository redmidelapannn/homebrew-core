class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz"
  sha256 "c928119229d4f8f35e20113ffb61f281eda267634a8dc2285af4b0ee27cf2b40"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "e4b16cb5930e9bcf9c6e3c9b05ce358cdb8c5efe3151f9873e0ad493b3f6a2dd" => :high_sierra
    sha256 "d82a48d086f151740313dc62cef0b029e7baad900fb7937718b0894ca613a39e" => :sierra
    sha256 "4048068872389b6f66e9ca9dc54243b392bce7bb59f15c39b009dd3153c7d799" => :el_capitan
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-gl",
      "--enable-libwebpmux",
      "--enable-libwebpdemux",
      "--enable-libwebpdecoder",
      "--prefix=#{prefix}",
    ]
    args << "--disable-gif" if build.without? "giflib"
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
