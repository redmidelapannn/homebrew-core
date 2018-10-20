class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
  sha256 "73aea623930c7d18a7a778eea391e1ddfbe90ad1ac40a91b380afca4b0e1dab8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8cbc1a6274ed2e107287ecfbb8e94fd7908688ce50d37db88281f1ed7b469e6e" => :mojave
    sha256 "a278e91ffd74391e5fcad9aa398b7b215160f429531426f0a7de31855f5d9889" => :high_sierra
    sha256 "022782c3c06daaacadbafbc1e0639867c3fede5ae9cb911e405d8006ade5fdd3" => :sierra
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
    assert_match /Chocolate Doom 3.0.0/, shell_output("#{bin}/chocolate-doom -nogui", 255)
  end
end
