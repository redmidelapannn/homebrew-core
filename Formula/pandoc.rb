require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.2.1/pandoc-2.2.1.tar.gz"
  sha256 "fe037f5fbb62fb27e7b1dbddfbd0aa45ea6e9fcdaff1f2203f7484c245b211b7"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 "e5acabf0077668460750b604d96361ac402c25a1ce6130ba1da552207cc89ee1" => :high_sierra
    sha256 "adbcc38ec9ddc4e215f17ebf87cb19c8cbf49d57f82e5aec88dabe53070e7c5b" => :sierra
    sha256 "190ed67e16c5ffd04e253a1e47505e28e53b70716ac7de82309e6d0ab50b47b1" => :el_capitan
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
