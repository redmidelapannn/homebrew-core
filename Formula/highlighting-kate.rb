require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"
  revision 1
  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e84a604f0a78503912629b47542c3325c47d7b4b3a0ca0009218d27b47c2ca53" => :sierra
    sha256 "5874dc7bb11ff5a18451ee4499430c08c5f755c7281ad936813abbcd57ad07cd" => :el_capitan
    sha256 "3349c3e02c0ad2949739eb5def47f3721b26c8fea0b852db72444c692eebbe82" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "-f executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line = '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">*hello, world*</code></pre></div></body>'
    assert_equal expected_last_line, test_output_last_line
  end
end
