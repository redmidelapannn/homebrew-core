require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.1.0/pandoc-crossref-0.3.1.0.tar.gz"
  sha256 "7330f63395b1075664490c0fa44aef9fd8b1931c9a646eb1dea2030746d69b86"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8ef399c562f680cd3f1b25bfeb827a6c74d44f4163116852a1ad85f54733da82" => :high_sierra
    sha256 "e3df80b60f709ca750b3d55bf0fb771b8057acd75d47b26c65a898b00deb6ab3" => :sierra
    sha256 "0ec85435757dc3d78b657010bbdcc6fec3bc234a639136b24e9d095f83ecb28d" => :el_capitan
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
