class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.10/imlib2-1.4.10.tar.bz2"
  sha256 "3f698cd285cbbfc251c1d6405f249b99fafffafa5e0a5ecf0ca7ae49bbc0a272"
  revision 1

  bottle do
    rebuild 2
    sha256 "ecebae98be5be3aa6f260c10587d2bdff51b0030d621d8d8b568f6486c323884" => :high_sierra
    sha256 "388609376b466b6cfffbca1517fd5a6000cef8156839e3870587db8da1761f5a" => :sierra
    sha256 "9613b3fc8ebfe92e12d1099b3074e4a6994d163d4be81bd39eefb30e42a28262" => :el_capitan
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "giflib" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libid3tag" => :optional
  depends_on :x11 => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"
    args << "--without-id3" if build.without? "libid3tag"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
