class Bane < Formula
  desc "The magic of Old Memes, now in your command-line."
  homepage "https://github.com/ctrezevant/bane"
  url "https://github.com/ctrezevant/bane/archive/v1.0.tar.gz"
  version "1.0.0"
  sha256 "3622fad27f0cbb3cc45f100463ccb296ed3cd6448f913313fd5e113cbe9ff5d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5573f4892c3db97431bdd8b62ec01702bcb9b321e1047295562a0c4da42e3b0" => :high_sierra
    sha256 "38b7a39ab706a4939e46694b3809617683a900f47708bc684706719990745adc" => :sierra
    sha256 "1f6480caac3e4b4555a2f7e2e1b9d3ed943dd44457e1dda15792b561977ab419" => :el_capitan
  end

  def install
    system "make"
    bin.install "build/bane"
  end

  test do
    system "#{bin}/bane"
  end
end
