class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.8-21.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.8-21.tar.xz"
  sha256 "c3be517875b582a746bdc813f1837d97e4925bfcf5468a7177e3c8adf88091b4"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    rebuild 1
    sha256 "20b95ea8bcdb4a3dd9496add52624a4877227af5cd43e202581a43dc7c42dfd3" => :high_sierra
    sha256 "4631d4db1bbbd02a795c0a7687fbc1cc261a9505cc36cdad0a6feb0385951d56" => :sierra
  end

  # Using LLVM with superenv would make the resulting binaries depend
  # on /usr/local/opt/llvm/lib/libomp.dylib instead of the intended
  # /usr/local/opt/libomp/lib/libomp.dylib, as superenv would add the
  # LDFLAGS `-L/usr/local/opt/llvm/lib`.
  env :std

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-libheif", "Compile with HEIF support"
  option "with-perl", "Compile with PerlMagick"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-libde265" => "with-libheif"

  depends_on "llvm" => :build
  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "libheif" => :optional
  depends_on "liblqr" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "openexr" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional
  depends_on :x11 => :optional

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --enable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-webp=yes
    ]

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"

    # Use LLVM Clang but do not depend on LLVM stuff (specifically, not the
    # libomp from LLVM).
    ENV["CC"] = "/usr/local/opt/llvm/bin/clang"
    ENV["CXX"] = "/usr/local/opt/llvm/bin/clang++"
    ENV["CPPFLAGS"] = ENV["CPPFLAGS"].split(" ").reject { |item| item =~ /llvm/ }.join(" ")
    ENV["LDFLAGS"] = ENV["LDFLAGS"].split(" ").reject { |item| item =~ /llvm/ }.join(" ")

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
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
