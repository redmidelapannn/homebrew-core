class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick-6.9.6-2.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.6-2.tar.xz"
  sha256 "39244823fe736626fb4ea22c4b6cb4cae30c6a27a38a02ecd774f0ce3c4d308d"
  head "http://git.imagemagick.org/repos/ImageMagick.git"

  bottle do
    rebuild 1
    sha256 "ae089871243afb6bf9c124175f3f57c6f8996abcaae87135f5cbde30d0191d39" => :sierra
    sha256 "b151154456a4749c61a55141994dd69eb2a388d19d7d25ac6dfacbd050a5b863" => :el_capitan
    sha256 "c29ef5b85d705d9422035f6235f62c0b76af51111aac230f0b2488a985001f3e" => :yosemite
  end

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-opencl", "Compile with OpenCL support"
  option "with-openjpeg", "Compile with JPEG 2000 support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "with-quantum-depth-8", "Compile with a quantum depth of 8 bit"
  option "with-quantum-depth-16", "Compile with a quantum depth of 16 bit"
  option "with-quantum-depth-32", "Compile with a quantum depth of 32 bit"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disable configuration files"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "xz"

  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended

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
  depends_on "webp" => :optional
  depends_on :perl => ["5.5", :optional]
  depends_on :x11 => :optional

  needs :openmp if build.with? "openmp"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    %W[hdri opencl openmp zero-configuration].each do |feature|
      if build.with? feature
        args << "--enable-#{feature}"
      else
        args << "--disable-#{feature}"
      end
    end

    %W[fftw fontconfig freetype jpeg magick-plus-plus modules openexr pango
       perl threads webp].each do |feature|
      if build.with? feature
        args << "--with-#{feature}"
      else
        args << "--without-#{feature}"
      end
    end

    %W[
      ghostscript gslib
      liblqr lqr
      libpng png
      librsvg rsvg
      libtiff tiff
      libwmf wmf
      little-cms lcms
      openjpeg openjp2
      x11 x
    ].each_slice(2) do |option, feature|
      if build.with? option
        args << "--with-#{feature}"
      else
        args << "--without-#{feature}"
      end
    end

    gs_font_dir = HOMEBREW_PREFIX/"share/ghostscript/fonts"
    args << "--with-gs-font-dir=#{gs_font_dir}" if build.with? "ghostscript"
    args << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"

    if build.with? "quantum-depth-32"
      quantum_depth = 32
    elsif build.with?("quantum-depth-16") || build.with?("perl")
      quantum_depth = 16
    elsif build.with? "quantum-depth-8"
      quantum_depth = 8
    end
    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}",
                           "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
  end

  test do
    test_image = test_fixtures("test.png")
    assert_match "PNG", shell_output("#{bin}/identify #{test_image}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %W[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
