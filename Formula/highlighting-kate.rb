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
    sha256 "659638add888eea87e52fecdb1c233671127418431102ca278d62a47a4e77c36" => :catalina
    sha256 "8bb0b202244ca7f2109cf05b967a1f7588acdce13f9904d6bd23b2e365364fde" => :mojave
    sha256 "1507c42a01735f37152d16913887c316c007681d05e6e2fbd9ac854a3971bbfa" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def install
    install_cabal_package "-f", "executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line =
      '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">' \
      "*hello, world*</code></pre></div></body>"
    assert_equal expected_last_line, test_output_last_line
  end
end
