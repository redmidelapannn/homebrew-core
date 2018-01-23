class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
  sha256 "34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a88fdbfb468c579a293323e72eea6aab179b10673c16525b85e171463dc66a2c" => :high_sierra
    sha256 "d6f500771e41158f7739bed5727584acc77f9eeb06343a1c35b8b239bcfa8512" => :sierra
    sha256 "67fa550d2b1496ed12b8b6328be1c73d5d40131a94f01778aedb8b08762b8e4d" => :el_capitan
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
