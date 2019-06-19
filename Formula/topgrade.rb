class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.3.1.tar.gz"
  sha256 "e16404d0156f0b9f3ff254053633320b0f1c4c8f1a2cecb92da674ff2a55297a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2a9b65d98cae65d0f6a1384a30ac7246a6cbd2e2cbb28ce041762dea9478e4c" => :mojave
    sha256 "1a1d2c70063dfbb6f3904dce47e0cfc7e7fd179420000ba4fe0aa6008ce58cd4" => :high_sierra
    sha256 "299d4ef2cac0c59dae51987f2538bf1a8889ea76d47bbbac36185de7f8017a7d" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
