require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.3/pandoc-citeproc-0.14.3.tar.gz"
  sha256 "7215f4e277419438f0e70b34935e3c3d16f3009bfd5f457bc6b57fd416ea47fc"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "a8427bd2da1ac0dad6b3a3c016050787d00c487a30879abc152647ac00bfbb6f" => :high_sierra
    sha256 "940824aeed9b8f18fdabb08aa7481725b07bf7bcf8d7c65d536666ac19778b4a" => :sierra
    sha256 "0ae1e0cf3d06b077316db21c21f5b7d50ecd2251cbb69e393f272031229c6e11" => :el_capitan
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
