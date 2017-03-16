class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://www.chocolate-doom.org/downloads/2.3.0/chocolate-doom-2.3.0.tar.gz"
  sha256 "3e6d1a82ac5c8b025a9695ce1e47d0dc6ed142ebb1129b1e4a70e2740f79150c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8930c8f08d631b7f1c0599de74767ab855c52f23bbb57e4a4d0e2e3447a58f4b" => :sierra
    sha256 "6ba290a7bfdb34d4234871f0a18fc840c895b9e16e1d6db9bbca973c19ad0802" => :el_capitan
    sha256 "845559f240825f398b43ab812e6b16fb0222bad32f9740a4b1505691c5a678f2" => :yosemite
  end

  head do
    url "https://github.com/chocolate-doom/chocolate-doom.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_mixer"
  depends_on "libsamplerate" => :recommended
  depends_on "libpng" => :recommended

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

  def caveats; <<-EOS.undent
    Note that this formula only installs a Doom game engine, and no
    actual levels. The original Doom levels are still under copyright,
    so you can copy them over and play them if you already own them.
    Otherwise, there are tons of free levels available online.
    Try starting here:
      #{homepage}
    EOS
  end
end
