class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "http://cms.ferzkopp.net/index.php/software/13-sdl-gfx"
  url "http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.1.tar.gz"
  sha256 "d69bcbceb811b4e5712fbad3ede737166327f44b727f1388c32581dbbe8c599a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "919480112fca9cf693890635cf7699c8e5cb0c3f47cd5202f9734973ccde15b4" => :sierra
    sha256 "37d2a8a61b924ab9d85879e926da1631f4961df44a7d7139b7938d5e0ddbd043" => :el_capitan
    sha256 "d3da07c35596bef92d7a30124e95c5678f7fc4a3a4db00dc0fc77d66a9cf90dd" => :yosemite
  end

  depends_on "sdl2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
