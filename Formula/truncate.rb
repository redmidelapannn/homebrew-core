class Truncate < Formula
  desc "truncates a file to a given size"
  homepage "https://www.vanheusden.com/truncate/"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
  head "https://github.com/flok99/truncate.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "debf52f04843ffbb3bfae16e0c55895d417560d65d69de852cd58a56f45c1e3f" => :el_capitan
    sha256 "093f0cb282ba5ed7829ebca6f4bfdb72d862e79280e5035f78dfe262aa5c2dd9" => :yosemite
    sha256 "4899c35ce99bf2c6f6c08f2566bd0d5f3c40d09a68502e9449abf6c194c527b5" => :mavericks
  end

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
