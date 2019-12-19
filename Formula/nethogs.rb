class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.5.tar.gz"
  sha256 "6a9392726feca43228b3f0265379154946ef0544c2ca2cac59ec35a24f469dcc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "086d32f392218955ae99c7c5d03d40d5d50326f1dc073c40b3b4010676575397" => :catalina
    sha256 "81c45eb47c80ecc8d94e83bec831f07e8be9b7657a4b72cad3d1bd7f03ee7fb1" => :mojave
    sha256 "93f9ea3c8ca1d1386fefbeda2d2b480e46894d2b9d8a6c53c84da8586d87b89b" => :high_sierra
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
