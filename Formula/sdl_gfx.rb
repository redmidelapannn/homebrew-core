class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "http://www.ferzkopp.net/joomla/content/view/19/14/"
  url "http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.25.tar.gz"
  sha256 "556eedc06b6cf29eb495b6d27f2dcc51bf909ad82389ba2fa7bdc4dec89059c0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6f8c203b36bcba9369ae28e33a1d82ae54dcd47778227973a85c7141ef38aa1d" => :sierra
    sha256 "23004d9dcf6047f0c5e32c6d2e0787bf716a8fca024078e0247bb462d4a4df6e" => :el_capitan
    sha256 "275d6036c6ea4c52b3271cfe5cf9b2fb7359e83db4a8cc1f8b8e99a0f8cb8261" => :yosemite
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
