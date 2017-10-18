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
    sha256 "c0126b5e472169d7bd092133ed3670881775785f9e285acced7be8f635a3faf2" => :high_sierra
    sha256 "06e282acad57d97c0fcbbbcde54616d44d87d72fb927214ebfb4955f4e5081ad" => :sierra
    sha256 "93554c12ecb5cb30a3e8be0d324fbd0115c70f5d907dc046a2ce34ad69da3caa" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3" => :run

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
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
