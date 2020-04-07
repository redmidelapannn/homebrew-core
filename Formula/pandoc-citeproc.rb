require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17/pandoc-citeproc-0.17.tar.gz"
  sha256 "47a9e7aac348d55eb935bee5ced30529974f4a680d67c38ea68be1d83edaf5b1"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "8b0c193d8fc23b9fb056d25d1c3ab8e0573a7ae089169936275327522bd8f389" => :catalina
    sha256 "6ae7e89e32e983b82d417101646041cad055f55fd7edd1d1fa5f84c0aa720523" => :mojave
    sha256 "4534a347e7d542c741ed1dfc58c8ce5cdc4731051417435fed618a56626af7ca" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build

  def install
    install_cabal_package
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
