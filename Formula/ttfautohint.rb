class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.3/ttfautohint-1.8.3.tar.gz"
  sha256 "87bb4932571ad57536a7cc20b31fd15bc68cb5429977eb43d903fa61617cf87e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b45a1d009c7c0217839ef5de3da0c0ca6e1f821f6347b50820a00b5845ae20a5" => :catalina
    sha256 "4a4ba000c7c966ef651da0874fa1ee8f420725caaa12a926be53daa2e73d3089" => :mojave
    sha256 "5b4df542f57e239435052ae1af86483945d34c21c595307a9e72e8f56a27e46f" => :high_sierra
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
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    cp "/Library/Fonts/#{font_name}", testpath
    system "#{bin}/ttfautohint", font_name, "output.ttf"
    assert_predicate testpath/"output.ttf", :exist?
  end
end
