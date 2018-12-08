class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.60/zboy-0.60.tar.gz"
  sha256 "f81e61433a5b74c61ab84cac33da598deb03e49699f3d65dcb983151a6f1c749"
  head "https://svn.code.sf.net/p/zboy/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "061d2130e4385990344525a32fa2fbf90ae0dda71eb4970ee6dd3149f33bcffc" => :mojave
    sha256 "6904e6dfa277a803d137b759a7df9d6052cb556b80c1ab62a34cce0fe83f3286" => :high_sierra
    sha256 "db961fae44b8f417f9e6ed14d065928e1da8bd19d5d3fc825f647cda3bf04c02" => :sierra
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
