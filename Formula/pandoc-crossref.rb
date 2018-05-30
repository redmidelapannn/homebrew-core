require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.2.0/pandoc-crossref-0.3.2.0.tar.gz"
  sha256 "2a0a916b35f0ef4d404e5ab137e4c775ae0067f78bebb25723123b546f7bcd5f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8a42b8b8cfceb1c23010f74b7d03160aee44aeeb0ff44d26efc7fcf83dff6943" => :high_sierra
    sha256 "42e8a78f36102311b6f8471d43fb77f35387ae6c8ae85388cd75189b154501e2" => :sierra
    sha256 "6c7c9a20faac94f52220326500d76bf080506d3640527ce0e7b2b5e8f8487a9e" => :el_capitan
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
