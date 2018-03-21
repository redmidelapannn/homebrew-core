require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.12/dhall-json-1.0.12.tar.gz"
  sha256 "4b493f17914f659ce42f656104b9ffbd7847f8d19455c447c8af33779cd39a9c"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b98a3ea9d620fa3d9beb0624398f3318d62968fc5fae6595953adc7df5c4595" => :high_sierra
    sha256 "9104c8cf9139a6af950a49be74fdee38886b46160f5f888c0fde42e4558dd922" => :sierra
    sha256 "761e9310efff0ca9d13fd75d4de8c5f7e3c1be7eb0b78a8c98e884aeb036b81b" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove when dhall > 1.11.1 is released
  # See https://github.com/dhall-lang/dhall-haskell/pull/330
  resource "dhall" do
    url "https://github.com/dhall-lang/dhall-haskell.git",
        :revision => "ed2041ee7709969ca63b4d9d1a82a34ffc145f3d"
  end

  def install
    (buildpath/"dhall").install resource("dhall")

    cabal_sandbox do
      cabal_sandbox_add_source "dhall"
      install_cabal_package
    end
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
