class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3c967314c091a8400e5204d78d3dbf45b8018729cdf73235aa9f468a19681933" => :sierra
    sha256 "a9fd34d5e97b55f4f09d1c393ef82702b65e3d707fd379eee47faaedd831ddb0" => :el_capitan
    sha256 "9acff3c7ccc5c06e484df4c4313e151ecf4303ca2f1a8973f928254ccc1283d6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
