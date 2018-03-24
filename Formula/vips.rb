class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.6.3/vips-8.6.3.tar.gz"
  sha256 "f85adbb9f5f0f66b34a40fd2d2e60d52f6e992831f54af706db446f582e10992"
  revision 1

  bottle do
    rebuild 1
    sha256 "fb6784fb54d6ee45ba42773bd5291701bdf34ab65b24930d5efa2f2378078700" => :high_sierra
    sha256 "06fd223d4e0bd426de3f8790b441ed88efc156a2a074e87ad1a14cdd800d780a" => :sierra
    sha256 "0c16787d36fbe7f9c81c7fb17eee84f7bccc0361f2decb4fc897233b592fd90a" => :el_capitan
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
      --enable-pyvips8
      PYTHON=#{Formula["python"].opt_bin}/python3
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    end

    # Let the formula find optional jpeg libraries before the main
    # jpeg formula.
    if build.with? "jpeg-turbo"
      ENV.prepend_path "PKG_CONFIG_PATH",
                       Formula["jpeg-turbo"].opt_lib/"pkgconfig"
    end
    if build.with? "mozjpeg"
      ENV.prepend_path "PKG_CONFIG_PATH",
                       Formula["mozjpeg"].opt_lib/"pkgconfig"
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
