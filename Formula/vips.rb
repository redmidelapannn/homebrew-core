class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://github.com/libvips/libvips/releases/download/v8.7.0/vips-8.7.0.tar.gz"
  sha256 "c4473ea3fd90654a39076f896828fc67c9c9800d77ba643ea58454f31a340898"

  bottle do
    rebuild 1
    sha256 "d3e2492949cfbeec2e3597f7d75b775386411e26b15b74ad054c90307a4c3aed" => :mojave
    sha256 "13cd94739a891cb3a6c7b2730c30c490f7c170e92a99e3f8e148d7d8b83a3b8e" => :high_sierra
    sha256 "c3794a1bf5970eac8904e57608b6072831f714ee255ce056f355f5a3e97afbe0" => :sierra
    sha256 "4b0afcd364d5b6428b38835b0fefa0011cd7bb16b630af74d7a9253bb63496ec" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "orc"
  depends_on "pango"
  depends_on "webp"
  depends_on "fftw" => :recommended
  depends_on "graphicsmagick" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional

  if build.with?("graphicsmagick") && build.with?("imagemagick")
    odie "vips: --with-imagemagick requires --without-graphicsmagick"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    elsif build.with? "imagemagick"
      args << "--with-magick"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
