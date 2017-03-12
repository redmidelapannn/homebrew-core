class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sf.net/project/freetype/freetype2/2.7.1/freetype-2.7.1.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.1.tar.bz2"
  sha256 "3a3bb2c4e15ffb433f2032f50a5b5a92558206822e22bfe8cbe339af4aa82f88"

  bottle do
    cellar :any
    rebuild 1
    sha256 "19ff07ae594ac1000f8dfed1f5a112ba4142c0418382ed61948781034bc7d4c4" => :sierra
    sha256 "d5d572b31bfb6524a5c9e810803eb1cc92888666d96eabb17bf91b0cb341210e" => :el_capitan
    sha256 "5707e72af4bd5840eda202dfe9c60804ecc9101071829bc1bcef955eee51db86" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
