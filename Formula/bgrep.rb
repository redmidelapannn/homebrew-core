class Bgrep < Formula
  desc "Like grep but for binary strings"
  homepage "https://github.com/tmbinc/bgrep"
  url "https://github.com/tmbinc/bgrep/archive/bgrep-0.2.tar.gz"
  sha256 "24c02393fb436d7a2eb02c6042ec140f9502667500b13a59795388c1af91f9ba"
  head "https://github.com/tmbinc/bgrep.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1e6cda53ac48a1248b8cdffcb8b25aeeab6b2b63a3fc252d3fe8b72651b85fce" => :el_capitan
    sha256 "d6da967043fe5590cf17d02ca4552a318009dda4ab4447a8b5e13a826ff5f45d" => :yosemite
    sha256 "e66cc0176b1f63998ee9b35dfc3f18a72e6ce4fc429db31cc7444b3eb60115db" => :mavericks
  end

  def install
    system ENV.cc, ENV.cflags, "-o", "bgrep", "bgrep.c"
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    path.binwrite [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
                   0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60].pack("C*")

    assert_equal "#{path}: 00000004\n#{path}: 00000009\n",
                 shell_output("#{bin}/bgrep 20d2ff #{path}")
  end
end
