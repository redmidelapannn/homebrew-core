class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.5.8/vips-8.5.8.tar.gz"
  sha256 "07a3b8966a816a834dd60dc1745ae1930f3bbe604e826986a5a2bbd7f45c5426"

  bottle do
    rebuild 1
    sha256 "cf8ef6faada042a764068e63880375ec9b0f32a240a047ad26cd090a3636eec3" => :high_sierra
    sha256 "414a4b555ad3c90f4dea64e110491a5978969fe5099d5123eae68261170b5b22" => :sierra
    sha256 "a3adb63b48f1179d86816a64509548310a01da6428b5c6b13eb612d2923aecbb" => :el_capitan
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
  depends_on "pygobject3"

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
