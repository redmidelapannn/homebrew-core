class Hex < Formula
  desc "Futuristic take on hexdump, made in Rust"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/v0.1.3.tar.gz"
  sha256 "7c5397b1f435d2e3b5280cf6186ea8fcc44690fda812e303b6b51b6bbececc5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "795f3f0785f4b1d0b87f2014eeefddf23f555ea3ceca967eb94f0856d2ef9366" => :mojave
    sha256 "18ab515b89b1c6b52fe1a280dbd6bcee4c48f76e29bfa1903a71a83964549f49" => :high_sierra
    sha256 "aa654db2dce71aa8517a05afa7b97d1c091098ed3567a2c0d62aac10ef234864" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"tiny.txt").write "il"
    output = shell_output("#{bin}/hex #{testpath/"tiny.txt"}")
    assert_include output, "0x000000"
    assert_include output, "0x69"
    assert_include output, "0x6c"
    assert_include output, "bytes: 2"
  end
end
