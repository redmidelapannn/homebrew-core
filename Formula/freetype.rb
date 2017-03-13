class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.7.1/freetype-2.7.1.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.1.tar.bz2"
  sha256 "3a3bb2c4e15ffb433f2032f50a5b5a92558206822e22bfe8cbe339af4aa82f88"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2ca1415134ab2f9b95c71c22e4fdc5d1468b91ac9b57c80e21135f09fb31713b" => :sierra
    sha256 "e856fd6ce4ec6dfb0a2553a440b1a33ae69dcea7e2f6782c0bdbc31a5ffcdfac" => :el_capitan
    sha256 "981b8420194b724575744c4e1c27c619b536931b8d463356d74563651d5081e1" => :yosemite
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
