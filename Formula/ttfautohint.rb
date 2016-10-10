class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.5/ttfautohint-1.5.tar.gz"
  sha256 "644fe721e9e7fe3390ae1f66d40c74e4459fa539d436f4e0f8635c432683efd1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2f9cd75c6604f6ff58f7cb824efefb814f149a416955c4be2e434cad8033460c" => :sierra
    sha256 "2da402f67605dfab42eed1ef85dff1d1c0e977762e530bd9cbb1642d83b4c4aa" => :el_capitan
    sha256 "40cabf188c4ce932aaccc7a102d9540326b8203e7f1b2e1aadfe6ecceb87d269" => :yosemite
  end

  head do
    url "http://repo.or.cz/ttfautohint.git"
    depends_on "bison" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "harfbuzz"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-doc
      --without-qt
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ttfautohint", "-V"
  end
end
