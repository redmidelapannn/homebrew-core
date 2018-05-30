require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.9.1/hledger-1.9.1.tar.gz"
  sha256 "630116f8b9f6edeb968e863600c9501628a805dd1319a5168ab54341c3fc598d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2688f71523dc7a70df9bd474e3bf589a32b688c77e157c3b7ced8915cf5c0955" => :high_sierra
    sha256 "a9261b98f313ab58819b1c21a3d49274514abe4574b6e89ea76e27db516bcb75" => :sierra
    sha256 "c60bf68f777a29b52c3b63dd842dcd04398dfb4b8fcda79567712c71cf1a27bf" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
