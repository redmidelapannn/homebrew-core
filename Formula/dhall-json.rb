require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.1/dhall-json-1.0.1.tar.gz"
  sha256 "ccf235f785207bedf29ea42d4ee26b44c2d2777fda8aa8d0306beaca43960726"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f0797a58cb31a5d4247eb4c23aee4e8062574f8446129fbf91d965e4896758d" => :sierra
    sha256 "6d195b6cd540124451529bbe63366eb7ebcdd31a775e779008eaf2be3512541a" => :el_capitan
    sha256 "3f75099351798d6ec4040caa18fbee7de09daf40ba2c29ecd545f23c303e149b" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
