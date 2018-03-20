require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.14.2/pandoc-citeproc-0.14.2.tar.gz"
  sha256 "853f77d54935a61cf4571618d5c333ffa9e42be4e2cccb9dbccdaf13f7f2e3b7"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 2
    sha256 "cc26c357bb8332818a704d2c18cc1ef9ee5017c11da307857ac80625e30996ad" => :high_sierra
    sha256 "d2484d8743e932e0fbd3ba19fc715022652a94f9d3380e42c9508144c615261d" => :sierra
    sha256 "324f29c90b2c65d497a07090c65851cc91c6ee516283bf27c4906b2a435146bf" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
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
