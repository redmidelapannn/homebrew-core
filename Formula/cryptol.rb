require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.5.0/cryptol-2.5.0.tar.gz"
  sha256 "910928617beb1434ad5681672b78ede5dda7715b85dcb8246fa8d9ddb2261cf1"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9d9ab0ce0ff2ebc62775ab4ac2083482cdde26c3f6b274192940ed36c24e00d" => :sierra
    sha256 "f7b6ce5ca31ecec45fed7065d94a0419a55cdce3743411e6187490f373db0f8a" => :el_capitan
    sha256 "cdfaa1c5e7f4033c959127a4cd4fe392a9c4a1fd7aa9e9d67bac84727b184164" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3" => :run

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
