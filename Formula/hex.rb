class Hex < Formula
  desc "Futuristic take on hexdump, made in Rust"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/v0.1.3.tar.gz"
  sha256 "7c5397b1f435d2e3b5280cf6186ea8fcc44690fda812e303b6b51b6bbececc5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "092dce6c1476adb7c91c3ca1c442e71ecbc30732bfba2cc0898ede6cb2d6f59e" => :mojave
    sha256 "ce94ab8342e82ac763f92e29c8e937cc751e1b75e96674f5d40fcd48eda59578" => :high_sierra
    sha256 "f4a110ecf0a23e8fc6fcead1da6f63d1a8fdaa8aedeb4e5fa7ad2cd6b7bbc630" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hex")
    assert_match "hex", output
  end
end
