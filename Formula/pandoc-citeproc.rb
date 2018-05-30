require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.3.1/pandoc-citeproc-0.14.3.1.tar.gz"
  sha256 "42c0b2c8365441bf884daa6202e6ed01b42181cf255406c88b3b31cd27cb467a"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "6322f7f04bb2c991348308b5ac14194c08f1f7edfe585608a4a8180133a12383" => :high_sierra
    sha256 "738d9e3b7339057b95c784b601e6e6f182d77227aaf5464c8a6ebce78b5c32cf" => :sierra
    sha256 "561968c2c8ba14b00e48bd5ce6ae175f6470dad0d8179f060aab5ceaaa72961a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<~EOS
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: 2005
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
