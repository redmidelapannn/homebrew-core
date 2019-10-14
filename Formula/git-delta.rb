class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta.git",
    :tag     => "0.0.13",
    :revison => "c2360a90d75e2d574a5d89d3c608ee77748e6d37"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7cb86b1fdb6ff568007708d7bb2c2603c96c378d53dc78cd82d17402f47144b5" => :catalina
    sha256 "f381fa8e7e29ea3f544921f9462258c9aefd36993c34c615e7f9751308b4b10e" => :mojave
    sha256 "05cbb86c800557673a3d56056945a4a25be28f3f6285cdb41a40083ee86a5888" => :high_sierra
  end

  depends_on "rust" => :build

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    # `cargo install` produces binary that have problems running on Catalina
    # rubocop:disable FormulaAudit/Text
    system "cargo", "build", "--release", "--locked"
    # rubocop:enable FormulaAudit/Text
    bin.install "target/release/delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
