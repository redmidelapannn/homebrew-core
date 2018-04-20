require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.3/pandoc-2.1.3.tar.gz"
  sha256 "4e0e9a891293f71a0d1309bbc5736e27601761888d9785ee19d8a4649b047008"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 "dfb5e6787a08d600009183ec3af4a086347669839517d898f04635552caf886a" => :high_sierra
    sha256 "98e2e7b50649198fe497fe10838ed55b42635e3c8148ca3871414a7b5df47273" => :sierra
    sha256 "084de70bed0df9a5960cb582d213cff8d75812e75f76f159d4056268a99660b8" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
