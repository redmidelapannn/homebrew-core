class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.8.tar.gz"
  sha256 "3b97d2fe8891336676ca28ff127b69e997f0b5accf2c7009b4517496929b462a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cb8bbd8405b18a2deec99b84ae954868264e75ba10c8410fa1b5b2fbf05dd7c8" => :high_sierra
    sha256 "efba031b6caef0615aa0cb43938dd1e0f62ac3daaa212fdf95ca54a58465e72d" => :sierra
    sha256 "2a8f8729b8eefcfdefdca075dc3900d6c92ed0dd0ce4e14d412448a41cedb677" => :el_capitan
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
