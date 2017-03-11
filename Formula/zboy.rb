class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.60/zboy-0.60.tar.gz"
  sha256 "f81e61433a5b74c61ab84cac33da598deb03e49699f3d65dcb983151a6f1c749"
  head "https://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "84ba5ded5ec100db3014e604349839588cbfd7e3403a237b8e0e6d9fca1c56ff" => :sierra
    sha256 "fd06f24fd2923f3c7514b235916d65c40d9fdd0833fc73b3ed4fce9dd68fa4eb" => :el_capitan
    sha256 "e2a75d33ceb3e11b7fcf1a662442d436d23c3b4ca11487f2f4948e0c82b76e81" => :yosemite
  end

  depends_on "sdl2"

  def install
    sdl2 = Formula["sdl2"]
    ENV.append_to_cflags "-std=gnu89 -D__zboy4linux__ -DNETPLAY -DLFNAVAIL -I#{sdl2.include} -L#{sdl2.lib}"
    system "make", "-f", "Makefile.linux", "CFLAGS=#{ENV.cflags}"
    bin.install "zboy"
  end

  test do
    system "#{bin}/zboy", "--help"
  end
end
