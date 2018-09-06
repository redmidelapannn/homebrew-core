class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.5.1/imlib2-1.5.1.tar.bz2"
  sha256 "fa4e57452b8843f4a70f70fd435c746ae2ace813250f8c65f977db5d7914baae"

  bottle do
    rebuild 1
    sha256 "0174474e2fdaac2443d5e0df0db63ea44cb2d7d070d61e17a25f0378f30f5d18" => :mojave
    sha256 "40d94a9bc178e41f50fb03891bb3d63c64bc67d0d7374d05f42b9c8e318f1897" => :high_sierra
    sha256 "7185b0a647b50e3f84fb009ab3124a379ead5afdfc62340887c20477db3c91e8" => :sierra
    sha256 "430af9843fe2fe524b0fcb59055e01f55d4a0af70efbd9a30206e37d76816a58" => :el_capitan
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :x11 => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]
    args << "--without-x" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
