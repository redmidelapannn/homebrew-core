require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"
  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4c9b2b8074f7c35f70e0bd08a9f52e92f21a132eea4db20010a9bbe4c0ed8d32" => :catalina
    sha256 "af9adb33c50d04b5c8ff73a3895934803915744bdbf9b25795e8d24d8b9cc5ed" => :mojave
    sha256 "2b467a307ceea71e5ac39cf54aec397b9d647d354ae74cd775135d22ebcfa67c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package "-f", "executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line = '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">*hello, world*</code></pre></div></body>'
    assert_equal expected_last_line, test_output_last_line
  end
end
