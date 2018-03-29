require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.13/dhall-json-1.0.13.tar.gz"
  sha256 "3a256300d29feb19181280272fd7df79aecbb82e3429084e9255bdae59fa570f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d98f262d294ba7c096dcc597ab2c379964128b9aeb7c1939fceff4e62f764f2a" => :high_sierra
    sha256 "9b1fd0cca3aa2f8f9037909686b6959afe10f2ba5c65c559f6999d5fb207e342" => :sierra
    sha256 "78d9f25ffe1252d752927f432a0ced722574c9a635e8efed94e039324a1af6f0" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
