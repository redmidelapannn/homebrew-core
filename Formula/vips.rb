class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.8/vips-8.5.8.tar.gz"
  sha256 "07a3b8966a816a834dd60dc1745ae1930f3bbe604e826986a5a2bbd7f45c5426"

  bottle do
    rebuild 1
    sha256 "6ce81463c077ccb745e900fae7e49bece6e6411805f265e9847e565da549aefb" => :high_sierra
    sha256 "e7e8e01a2453b45051f0c5529fe4815c89b98d837341b4b773c9af20d3b9f4ed" => :sierra
    sha256 "d190fbe4e38274cbdace6149864e0495d2441187e34db519c59ade53b112d5ea" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "orc"
  depends_on "pango"
  depends_on "py2gobject3"
  depends_on "fftw" => :recommended
  depends_on "poppler" => :recommended
  depends_on "graphicsmagick" => :optional
  depends_on "imagemagick" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "mozjpeg" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional
  depends_on "webp" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    end

    args << "--without-libwebp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
