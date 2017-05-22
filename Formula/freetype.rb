class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.8.tar.bz2"
  sha256 "a3c603ed84c3c2495f9c9331fe6bba3bb0ee65e06ec331e0a0fb52158291b40b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b31e9ee97d8b67230b5847da6a440fdf80ae5a555b80e8a6fb49c8077e44be7" => :sierra
    sha256 "eda0dbcd36608340843b79e0311dab4c130b137a10c1207b72f1b51d1118ceb1" => :el_capitan
    sha256 "17d9132686ed0dc929eb8af35006329da9f11de3bd0c45da1254574aaeef6f4b" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  depends_on "libpng"

  def install
    # Enable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)
    inreplace "include/freetype/config/ftoption.h",
        "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
        "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"

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
