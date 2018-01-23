class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.2.tar.gz"
  sha256 "72df075aef91fc4585098ea7e0b072d416ec7599aa10473719fbe51e9b8f6ce8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f93511434b2b041ad206824598525c1e867d4b8db803865e520c64fc1050fa4" => :high_sierra
    sha256 "2ef1ee0c6b27d355ffeed670acebc902d80faabbe4b7f6495b6f28142fad08a3" => :sierra
    sha256 "9541d03204907b0e06ce9d77f49f96d565f65e2ade09b90ecc93aa80af8b0b21" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

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
