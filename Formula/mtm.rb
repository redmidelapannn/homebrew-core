class Mtm < Formula
  desc "Perhaps the smallest useful terminal multiplexer in the world"
  homepage "https://github.com/deadpixi/mtm"
  url "https://github.com/deadpixi/mtm/archive/1.0.1.tar.gz"
  sha256 "cb1758d810860d25c7dc6d6d5440ad79055a22935f521be7d7d9fae40124add8"

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
