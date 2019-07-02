require "language/haskell"

class DhallText < Formula
  include Language::Haskell::Cabal

  desc "Template text using Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-text"
  url "https://hackage.haskell.org/package/dhall-text-1.0.18/dhall-text-1.0.18.tar.gz"
  sha256 "4d6f9477806cfe32ee415ca5763c1c0ded7b3137215a619a2fd663fa8e919bdb"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7640e83d6ae129321477428b49b6e4c2ab57a7f58adb2b6988d774fed153d5e" => :mojave
    sha256 "7a7028d74908e12d298d68424aedeb6c6e28ad074b7beb7eb450d3820f6c03d9" => :high_sierra
    sha256 "97cfb0b71e72ccde6bb364c7a3f11181f92a3df19e6682ab10865ff2800b732d" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "ABC", pipe_output("#{bin}/dhall-to-text", "\"ABC\"", 0)
    assert_match "123456", pipe_output("#{bin}/dhall-to-text", "let x = 456 in \"123${Natural/show x}\"", 0)
  end
end
