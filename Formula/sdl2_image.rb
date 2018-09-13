class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3.tar.gz"
  sha256 "3510c25da735ffcd8ce3b65073150ff4f7f9493b866e85b83738083b556d2368"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4f485b5e1a3a8ff6c83f0733ac55b72a2ac9c4fae8d9754efa4d8cf677c84171" => :mojave
    sha256 "4cb57832c5807da59b7e85eedf895e34119520757646ad2fc6ea4a3a64e4f526" => :high_sierra
    sha256 "18e696a1fe56234c2b9d0e4a5281e996eae8e598411af859c970e36a95045045" => :sierra
    sha256 "958b842a1d958862f18a0de4fdae79add0a14af2b400e6ba26ed7fe9bdb883ad" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int success = IMG_Init(0);
          IMG_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_image", "test.c", "-o", "test"
    system "./test"
  end
end
