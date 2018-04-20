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
    sha256 "73eb7da98d22d2b8f1c080ca98e62c9b301526f7ed2f365142203483d51d9c37" => :high_sierra
    sha256 "c67d3da206a903a798f2f4832dd286868812c3a4287847439d679838567d3758" => :sierra
    sha256 "9bca430dedb58bb76e5b3d2ffa739b018ad36e083395e795c77e06f64626e985" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
