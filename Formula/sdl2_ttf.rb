class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
  sha256 "34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e6ba46aa78c45cee050d347736b2db86a81827909a4d2506e8129a0ad48b8d69" => :high_sierra
    sha256 "9863bc46d3488633cfbcf1c021386e6e5b3e7bd72c83a7f334cdbd13772f1553" => :sierra
    sha256 "73f6742fae1992e4d5023c81fd4772f6eef543144329064bd3fbd737a832033c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "freetype"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_ttf", "test.c", "-o", "test"
    system "./test"
  end
end
