class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
  sha256 "73aea623930c7d18a7a778eea391e1ddfbe90ad1ac40a91b380afca4b0e1dab8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a5a608d28fa507e50ea511151ea4579705a3e6482012532b75d9c7059606e9d" => :high_sierra
    sha256 "197070a29d01f2fc3b9300b47c0f17cdc6da06a997105b295b36630af66831c7" => :sierra
    sha256 "c8e490bbf308d5ad793b64bd5a00971de51556324671707b46d56c0b8b6735e7" => :el_capitan
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
end
