class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.9.0.tar.gz"
  sha256 "10c5a4659d8ad895a78077e848623eaf6c0a868232ef204464370ba1e45ecf2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "03069ec1e3c31b51a168d4d54ca2d3d71de4b6c532b3a36dba5e3976ff8f4eb7" => :mojave
    sha256 "7fb9f2fbe9597e188fe5a2b30a986f44e4d5318e4d1e383870a65e45ab4c095a" => :high_sierra
    sha256 "9bb0e6a67b38ab22f077387535a7eda9c3bfc3046d991eb91e15cccd5d49c9ac" => :sierra
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
