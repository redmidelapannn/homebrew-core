require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.11.1/pandoc-citeproc-0.11.1.tar.gz"
  sha256 "4e28b88a178875499abea515550c91b68212acca6b5b85af8814e6e002eb296a"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "585659a098298818d0fd5e65f63a4bc2eeb2786894b6c6723522a1752953abd9" => :sierra
    sha256 "fdd1c85154f22a9280ed502676edda4514725b99b903c46da057a6e8af82dc91" => :el_capitan
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
    (testpath/"test.bib").write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<-EOS.undent
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: '2005'
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
