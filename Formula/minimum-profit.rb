class MinimumProfit < Formula
  desc "Console-based editor by Ángel Ortega"
  homepage "https://triptico.com/software/mp.html"
  url "https://github.com/juiceghost/homebrew-mp/archive/v3.2.13.tar.gz"
  sha256 "176aea01f4334605ea0cc89caf7ab0a0c600c8367b8a4779fcb7d54983af1dac"

  bottle do
    cellar :any_skip_relocation
    sha256 "9817bd8f57e74dfc95a6b029b64fd78826cfbbb05f5a3d1a0f3ac7e63b570541" => :catalina
    sha256 "e257c37bd47ab44606976ba312bdfcaf02cb9844da10e317b94f95d3ce342dad" => :mojave
    sha256 "bb84b9229f7a35c4c079ca10eacd5c1dbc07838ea23ddfcf1ff3264371acdce3" => :high_sierra
  end

  def install
    system "make", "mp"
    bin.install "mp"
  end

  test do
    assert_match "3.2.13", shell_output("#{bin}/mp --version")
  end
end
