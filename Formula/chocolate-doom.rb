class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
  sha256 "73aea623930c7d18a7a778eea391e1ddfbe90ad1ac40a91b380afca4b0e1dab8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b0371661b38d404ed277faaab9927839c40cab4bd958bb9c9e2615f9ae38b251" => :mojave
    sha256 "b0b44a7db3d201b84b5cd1cfc3953e257aca930d1bf276003093b9e5f8eb7e57" => :high_sierra
    sha256 "ddf9a7b07d386236b957c85d872c16c764c142ef1743c396d3dae6000df25c4f" => :sierra
  end

  head do
    url "https://github.com/chocolate-doom/chocolate-doom.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sdltest"
    system "make", "install", "execgamesdir=#{bin}"
    (share/"applications").rmtree
    (share/"icons").rmtree
  end

  def caveats; <<~EOS
    Note that this formula only installs a Doom game engine, and no
    actual levels. The original Doom levels are still under copyright,
    so you can copy them over and play them if you already own them.
    Otherwise, there are tons of free levels available online.
    Try starting here:
      #{homepage}
  EOS
  end

  test do
    assert_match "Chocolate Doom #{version}", shell_output("#{bin}/chocolate-doom -nogui", 255)
  end
end
