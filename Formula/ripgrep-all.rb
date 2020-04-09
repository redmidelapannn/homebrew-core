class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/v0.9.5.tar.gz"
  sha256 "7939a9cb5ee8944f5a62f96b72507241647287b1f6257f3123c525ffb7e38c44"
  head "https://github.com/phiresky/ripgrep-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ecbc6686212761db6d4cc72416c269d7a4b4ea9223168d3c5ab290a7a5972b8" => :catalina
    sha256 "b24b16ee00f5b6aac79f759aadbe4ded837fc968fa7a757746f5c91474031e3b" => :mojave
    sha256 "64b7891f4e7bdd25e7574eb66abb8041e46385305d686c981984643f9c3cea6b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
