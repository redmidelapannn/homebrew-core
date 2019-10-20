require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.27.0/dhall-1.27.0.tar.gz"
  sha256 "e189fecd9ea22153252609a4d7c5cc4d61f2c36326b53758b61e5a851e701712"

  bottle do
    cellar :any_skip_relocation
    sha256 "a07016b404e5befd0f0b0b2e02a88416bbc95f139b08939d527c8452c8147628" => :catalina
    sha256 "d6e9732055061df9f4e92817832adf5bc51636564281798e63cae266b353418e" => :mojave
    sha256 "966ec63ea2e087117273d1f7d3cf8389b34389947cc6fad5d76e55e06f1cb6c7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
