class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"
  sha256 "15ce8a7e5a23dafe8177c8df6e6c79b6749a03fff1e8196742d3571657609d21"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4e3403f9bb2632d513ed9c898e307d5bd44c34fafe950da0a6f3d8a0a2499212" => :sierra
    sha256 "9d4850c5d2af4240b271df5f9288ac6345b6c7deca3560bbff0e7a2b806e3e20" => :el_capitan
    sha256 "320e7cd3d07ee7b76e5af33468ee951e220d922eaf603413156b64c2a9454f32" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
