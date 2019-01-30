class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.60/zboy-0.60.tar.gz"
  sha256 "f81e61433a5b74c61ab84cac33da598deb03e49699f3d65dcb983151a6f1c749"
  head "https://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6a70cc5d9ce9998cd75fff4e56ad11f496b360a06e287b5242acd4d70dfaeae3" => :mojave
    sha256 "54481aaef4e3911ec329df6499f87da3e15b9d390aa5d2aff7fc4546d1bb02b7" => :high_sierra
    sha256 "1d56c00001fa401948cd6703edc0af0a986976fbac047f7330101e33d0f09f38" => :sierra
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
