require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.9/hledger-1.9.tar.gz"
  sha256 "b5fa4c5cce79210342524503fe5b512f7ec96c00b68a65627ee77daf72809a82"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4c06cbb5feb19daeafc9b454b989a83927950673eb29cab53fc0ab15c2a441fc" => :high_sierra
    sha256 "7548afc08020bfdb75c423c2b66239e99df5f08beb5bf948e3edeafd1ff7b32b" => :sierra
    sha256 "dcde701b3fe1622b2f77c322b8f9458711fcc3c03284514b9132929063443c71" => :el_capitan
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
