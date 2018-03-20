require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.5.0/cryptol-2.5.0.tar.gz"
  sha256 "910928617beb1434ad5681672b78ede5dda7715b85dcb8246fa8d9ddb2261cf1"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d8efc21fd87a8794f4b8e9a7d514105a3d451c1fa674eff8a8c8f5f1ca6dc563" => :high_sierra
    sha256 "74e8225c23eede7b9492ade0237165ddb48020b32d610a5f96b797696429a0e2" => :sierra
    sha256 "8e635e99d3b87b7ff10a08462eaa980ddb65c0177e081d4346ccb3dd451c0f61" => :el_capitan
  end

  depends_on "ghc@8.2" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

  def install
    # Remove the "happy<1.19.6" for cryptol > 2.5.0
    # See revision 1 of https://hackage.haskell.org/package/cryptol-2.5.0/revisions/
    if build.stable?
      install_cabal_package :using => ["alex", "happy<1.19.6"]
    else
      install_cabal_package :using => ["alex", "happy"]
    end
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
