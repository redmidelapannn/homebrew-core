class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
  sha256 "34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c4a58181e3317ca77a9b8088e6e562b71a4775499d1e5e83f1ba098fd8a7212" => :sierra
    sha256 "3021169de8576f5b015815cee1d4a053e80342e9e81e4301ac821257a0bd4f0b" => :el_capitan
    sha256 "bad51543067e17e8674c5c89b597ff8ce3eb1254986ada5d8456463052e3a495" => :yosemite
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
end
