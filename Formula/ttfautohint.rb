class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.2/ttfautohint-1.8.2.tar.gz"
  sha256 "386741701596a8b2d5fb744901922ed2bd740490f7e6c81e5d7e83ac677889a7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c0b3b9152ca1158195f5c7de003bc518fc081bb0c0193a6af8652ccb13839e46" => :mojave
    sha256 "4612605b4a675a337d003fc01b0136dd958a66a5433542e119773ca0bba4b903" => :high_sierra
    sha256 "4a1f25a6f67c578306fc8fed842b8a84d24f697135d5831f49369f535551c105" => :sierra
  end

  head do
    url "https://repo.or.cz/ttfautohint.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-qt", "Build ttfautohintGUI also"

  deprecated_option "with-qt5" => "with-qt"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "qt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-doc
    ]

    args << "--without-qt" if build.without? "qt"

    ENV["QMAKESPEC"] = "macx-clang"
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    if build.with? "qt"
      system "#{bin}/ttfautohintGUI", "-V"
    else
      system "#{bin}/ttfautohint", "-V"
    end
  end
end
