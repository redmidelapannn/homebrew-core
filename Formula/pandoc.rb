require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.1/pandoc-1.19.1.tar.gz"
  sha256 "9d22db0a1536de0984f4a605f1a28649e68d540e6d892947d9644987ecc4172a"
  revision 1
  head "https://github.com/jgm/pandoc.git"

  bottle do
    rebuild 1
    sha256 "807bf5dd930c06c7a8143981405aed01bff31bcb9fcbf465beb35d057c90fcae" => :sierra
    sha256 "59ddd2ce9cd92813c1d698d9d15f10a9d189cb71e7ab0e9c4f964b78c0a11e8c" => :el_capitan
    sha256 "ea392eb37791e616436010124960cdbab46e59a0a2029154a04b98bd79622d86" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      if build.stable?
        # remove for > 1.19.1; compatibility with directory 1.3
        system "cabal", "get", "pandoc"
        mv "pandoc-1.19.1/pandoc.cabal", "pandoc.cabal"
      end

      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<-EOS.undent
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<-EOS.undent
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
