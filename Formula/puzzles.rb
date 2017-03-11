class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  version "20161228.7cae89f"
  sha256 "96b6915941b8490188652ab5c81bcb3ee42117e6fb7c03eed3e4333fa97ed852"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "563a799fe9fdcffd1e32797db4fd708366610e6652cba51d64f8067bdd1aa545" => :sierra
    sha256 "563a799fe9fdcffd1e32797db4fd708366610e6652cba51d64f8067bdd1aa545" => :el_capitan
    sha256 "48bcfdebbefb2115b304945e562f88a88d7315f35f1e5109a1a8900675fb14cd" => :yosemite
  end

  depends_on "halibut"

  def install
    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    File.executable? prefix/"Puzzles.app/Contents/MacOS/puzzles"
  end
end
