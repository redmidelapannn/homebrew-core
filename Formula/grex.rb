class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v0.2.0.tar.gz"
  sha256 "79eb86a1e27b3701527f8524a64f2c1a32edf9b7474a2c5cddc3e9e56f21567d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ab6e3e0421fd841ce1ae5209ad3486891f7bca2965d72f4de7900aad357d2e0" => :catalina
    sha256 "9477421621f94cbea22b45cf45bc488597afc2a5b864bf768425dafd4ec44817" => :mojave
    sha256 "71aca9b4ddfdb09d6234e6c8ae48c30bf25781093b896ea419865739453fcb8e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
