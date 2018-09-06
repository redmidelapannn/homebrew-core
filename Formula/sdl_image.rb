class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 7

  bottle do
    cellar :any
    rebuild 1
    sha256 "4a3a170a0ca2f6513524df0ed9839b0d948be8aff3f77e5c6c3057e28534303a" => :mojave
    sha256 "f41c3aec4b73c857feb12be0fcd6e1e9a19b337726708fa8556ce00074022899" => :high_sierra
    sha256 "13de33d2d09810056e9db28d3c42eb91404d0b6c15a75824cad083aac48c4c38" => :sierra
    sha256 "20ef6b1f63aeb902f1047af740aac5e89ae1e331f1a65b31d9af701f8975e14e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl"
  depends_on "webp"

  # Fix graphical glitching
  # https://github.com/Homebrew/homebrew-python/issues/281
  # https://trac.macports.org/ticket/37453
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
    sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
  end

  def install
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-sdltest",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end
end
