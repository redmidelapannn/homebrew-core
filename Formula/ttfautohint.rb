class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.2/ttfautohint-1.8.2.tar.gz"
  sha256 "386741701596a8b2d5fb744901922ed2bd740490f7e6c81e5d7e83ac677889a7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a62918efda8b5577d511603305508045a86d8777274dc86db139ef9f351b85e8" => :mojave
    sha256 "f81ec5b4421d4fbd7cba01356033626c5556271080956e32722888309190a8f6" => :high_sierra
    sha256 "9247905a058d75071afae5be0395edc5086a3e43f8e21d1ca69b1bfd06a32891" => :sierra
  end

  head do
    url "https://repo.or.cz/ttfautohint.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-doc",
                          "--without-qt"
    system "make", "install"
  end

  test do
    system "#{bin}/ttfautohint", "-V"
  end
end
