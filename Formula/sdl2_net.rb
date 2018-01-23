class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"
  sha256 "15ce8a7e5a23dafe8177c8df6e6c79b6749a03fff1e8196742d3571657609d21"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef61058370338198668f4070a6b70f4d2d712810eb5b41ce7240bb8a3bc98884" => :high_sierra
    sha256 "dd5c940ad8fe9090f1fe388b16de7d609697f7e1a5740cb93d6613ec54df9308" => :sierra
    sha256 "645ba99bbaff1090ac4d1859535d9d2a9996524f35a52bbf2cae7e4a53a94f42" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_net.h>

      int main()
      {
          int success = SDLNet_Init();
          SDLNet_Quit();
          return success;
      }
    EOS

    system ENV.cc, "-L#{lib}", "-lsdl2_net", "test.c", "-o", "test"
    system "./test"
  end
end
