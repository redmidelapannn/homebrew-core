require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.10.3/pandoc-citeproc-0.10.3.tar.gz"
  sha256 "2f6233ff91a9fb08edfb0ac2b4ec40729d87590a7c557d0452674dd3c7df4d58"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    rebuild 1
    sha256 "61584de15d4b4517c61b7b0cb31ed6fbd009b474de68744b1a4e00c61d58a16f" => :sierra
    sha256 "e02f189cc14ed0a7f1d613723eb4f41b3497db6bb89e105fc6a194f3da6694e9" => :el_capitan
    sha256 "0de441a348a18a3fc2ed5693d0e6c04342e087f4a730fdab60d35086eb8591d4" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    # Build error with aeson >= 1.0.0.0: "Overlapping instances for FromJSON"
    # Reported 27 Oct 2016 https://github.com/jgm/pandoc-citeproc/issues/263
    inreplace "pandoc-citeproc.cabal",
      "aeson >= 0.7 && < 1.1, text, vector,",
      "aeson >= 0.7 && < 1.0.0.0, text, vector,"

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
