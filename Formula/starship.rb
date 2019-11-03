class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.2.tar.gz"
  sha256 "bc57c0083bb02a7d6b4fb6c7a9b7f6d1ecb315f7294aeb71834e2d4660a2fa46"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07d6ce66606c26004ab65b17a174aacd4ea8d0c20f8051fe6efbf7a9693badc1" => :catalina
    sha256 "2f78a92c93dfd67576c3864de405856107156cd6a92350a45d25c612645fc6cf" => :mojave
    sha256 "a47200158b93f3dffdfe8dfc54f40f56ba084e8c7b974dc72ecbfc3fe34ddd1b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
