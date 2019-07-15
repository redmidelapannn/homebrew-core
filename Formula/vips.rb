class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.8.1/vips-8.8.1.tar.gz"
  sha256 "a0ee255a2a1ebfea5b2dff2a780824d7157a78c010d7ddd531279aacefbf2539"
  revision 1

  bottle do
    sha256 "bb1f2ee240b4fc080a89f22476152a61531ef419f4585dbfbfa9a2c88b7e6009" => :mojave
    sha256 "f5cd7ac5a05f8f0ab054643fe360b203b4b3ed5d516991a37ca42b39931972e2" => :high_sierra
    sha256 "f2c65eb94004f89ec850799a39d13896cae1f494454211e9f3b737ab5acad6cb" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libheif"
  depends_on "libmatio"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openslide"
  depends_on "orc"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-magick
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
