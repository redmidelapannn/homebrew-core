require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.2/highlighting-kate-0.6.2.tar.gz"
  sha256 "728f10ccba6dfa1604398ae527520d2debeef870472fe104c2bf0714c513b411"
  revision 1

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "7584648b640e8594946234ccbc4c38907735ee8d5296e4abc52111a03f3da697" => :el_capitan
    sha256 "08f3500546721888de308f1e421024f5128e7362cd508b6774c3fa067dd3442c" => :yosemite
    sha256 "2d325d957b0b2030c8c1977b790fa094d90a1c22217e70b294f4138ca40b087c" => :mavericks
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
