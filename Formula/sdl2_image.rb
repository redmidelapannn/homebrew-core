class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "98260149f939bfe1aa4afd8ae7b57e9c97127e78ca8d90e2f4af01940a804624" => :sierra
    sha256 "df70bdfee57cece2ffe109f1078eb2d3972098cbf3d4119bdf14ffd7a5c44e47" => :el_capitan
    sha256 "5e2dc44d74d8060b34ab4d2661f0b4b054dfa125ccdd326cf4f184825a085a5f" => :yosemite
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
                          "--prefix=#{prefix}", "--enable-imageio=no"
    system "make", "install"
  end
end
