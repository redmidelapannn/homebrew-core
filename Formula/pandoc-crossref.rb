require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.0.3/pandoc-crossref-0.3.0.3.tar.gz"
  sha256 "2c2f35497d7df37b8625a93e70982c4d68fcf5a92360809fb546cac2cdd144f0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "56c45356eec9b5e08a620dc62af0923078391ac54d9882ef65de1c7756171112" => :high_sierra
    sha256 "d5a01d206386410c309c22a479ecd357b5e1407661a8ff587a83230359c4cc93" => :sierra
    sha256 "29c30bf01ac043f1a8fdcb9435da4d41f6c3a240f4897476497196c13d957437" => :el_capitan
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
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
