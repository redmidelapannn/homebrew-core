class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.2.tar.gz"
  # Because Google-hosted upstream URL gets firewalled in some countries.
  mirror "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.5.2.tar.gz"
  sha256 "b75310c810b3eda222c77f6d6c26b061240e3d9060095de44b2c1bae291ecdef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a25016c6a55fa55db66f506b31ab8ff7df3f506bba211ef8156b068b21ba0541" => :sierra
    sha256 "d813d7ecbcf85fc7b03ae9eb73e7b6c56e7059b3c0153bb8d6e78d3958336779" => :el_capitan
    sha256 "f650ed4456086a6da4ed510b15ab135f87af936763cd3cda0ec2fa69d50aa4ee" => :yosemite
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
