class Mrboom < Formula
  desc "Mr.Boom is an 8 players Bomberman clone"
  homepage "http://mrboom.mumblecore.org"
  url "https://github.com/Javanaise/mrboom-libretro/archive/3.3.tar.gz"
  sha256 "b96dec61de573a3767b2a6e819c79ea404fd7cb90a35f1fcb2e230714beb9acc"

  bottle do
    cellar :any
    sha256 "753c418815def03354585e376467db9f06d17f8f649d2e2fcd84e050f60296b7" => :sierra
    sha256 "310a26a11cd4348a267486a14d30b6f1b1f269ada3814c36fd7bdc579bc46c77" => :el_capitan
    sha256 "42626b355c152b566c6d381dc2218b81fcbae30227a986b2d16b411048e691f5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "minizip"
  depends_on "lzlib"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    bin.install "mrboom.out" => "mrboom"
    man6.install "mrboom.6"
  end

  test do
    system "#{bin}/mrboom", "--version"
  end
end
