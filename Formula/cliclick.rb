class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.2.tar.gz"
  sha256 "11245e06030a1603200d56ef5cbb3b0ee182ca6fe11f1d88504b137d7ecc0d8a"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a34c57d1990c5899e69af1b739f815e6f280b7616caf15572de1c77ed893871b" => :el_capitan
    sha256 "08cf09b6aecdd5d8fff95d8cd27191646247eb0231baf6edb5e14da9ddd1e05c" => :yosemite
    sha256 "37665ec54ff089929193341fc5c19ca9caa854b38c313b2187a1d5c44cebd47a" => :mavericks
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
