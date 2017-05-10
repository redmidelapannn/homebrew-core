class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  version "20161228.7cae89f"
  sha256 "96b6915941b8490188652ab5c81bcb3ee42117e6fb7c03eed3e4333fa97ed852"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8e864c3b90545efda1ef9fad2f960e44e1585afff1d5f7aa0b3c5f5a481e2046" => :sierra
    sha256 "09a2f6bb7b9f8d224d6a1b5a5987ebed07292c58c01d0a237eab61133b649cf9" => :el_capitan
    sha256 "015f15ded9c88e632c35f65437ce188aa301c1c9cdbdd0760227eba3a1fa040b" => :yosemite
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
