require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.5/hledger-1.5.tar.gz"
  sha256 "0185e2d24a72eae917ca08a8d1de42dceeb93357331c1162156a7adaa092af56"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bef8080fc56194ece4f9872824b2722f682a764396f14fcaf816445c3f7c3bd4" => :high_sierra
    sha256 "b65e6895e88800dc6ece4d5327593a63683722379a4e6012808c180800e08a48" => :sierra
    sha256 "60c1164afd6af49166d01a47039856e0cc6a70038e505354d2effab2492a269c" => :el_capitan
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
