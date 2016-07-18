require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.1/pandoc-citeproc-0.10.1.tar.gz"
  sha256 "ebc3eb3ff95e97ebd46c0918a65db2da021de2a70d02dc85ca5b344ea5c21205"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    revision 1
    sha256 "00fe98843849aaca0072f19a63e64c0911e01bf2978e02f83b5344c7b36b6611" => :el_capitan
    sha256 "557896140e9c0e30a892e7811967a480acd071bb8b41ccec63edf589592865e7" => :yosemite
    sha256 "c235d3f3804c87140fc148a1e9b384f5312a9b1207c31bf3b2b273572b20b580" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
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
