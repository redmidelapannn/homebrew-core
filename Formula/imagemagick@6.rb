class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-12.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-12.tar.xz"
  sha256 "54549fe394598f6a7cec8cb5adc45d5d65b8b4f043745c6610693618b1372966"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    rebuild 1
    sha256 "50fe4f5014d285d95987b132124361826626d72077922716cdb3d4e963cbd073" => :mojave
    sha256 "4cdbb2f501ac311da238a833215d81c0bbdd1f9c3f2ddb056dcad1b8ce44afb6" => :high_sierra
    sha256 "0a473513948595b19fbdacae059c30b1db5624304ec7b30e8f4cc92160b5fd11" => :sierra
  end

  keg_only :versioned_formula

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-gcc" => "with-openmp"
  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "xz"

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "liblqr" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "openexr" => :optional
  depends_on "openjpeg" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional
  depends_on "webp" => :optional

  if build.with? "openmp"
    depends_on "gcc"
    fails_with :clang
  end

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
    ]

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "webp"
      args << "--with-webp=yes"
    else
      args << "--without-webp"
    end

    if build.with? "openjpeg"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--enable-zero-configuration" if build.with? "zero-configuration"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
