class Mtm < Formula
  desc "Perhaps the smallest useful terminal multiplexer in the world"
  homepage "https://github.com/deadpixi/mtm"
  url "https://github.com/deadpixi/mtm/archive/1.0.1.tar.gz"
  sha256 "cb1758d810860d25c7dc6d6d5440ad79055a22935f521be7d7d9fae40124add8"

  bottle do
    cellar :any
    sha256 "e8bc0fbd2f7dbeae184813959e2f56d7f92cd99d42fa555a8c0927e4fcc9439d" => :mojave
    sha256 "4dac3f7eac84aa05b9d8582973c8505bff867952789af287aa51d43dbe1091d1" => :high_sierra
    sha256 "7089d0490f208817ae43b9c7d55418e61e027b410d72086e2ddd0d31c34c3d35" => :sierra
  end

  depends_on "ncurses"

  def install
    system "make"
    bin.install "mtm"
    man1.install "mtm.1"
  end

  test do
    # mtm doesn't provide any immediately returning switches,
    # and it's really hard to even pass anything to it.
    # So, no test for now.
    system "true"
  end
end
