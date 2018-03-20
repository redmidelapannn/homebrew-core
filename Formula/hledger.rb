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
    sha256 "70df5598b3c39dfc573ee5076f3375d3b94a1d5999face7a41b5cd556c110912" => :high_sierra
    sha256 "988c60b998e73d974536dab02a76b93a2b168e8bdf779b342bac0c00678091f7" => :sierra
    sha256 "c13e27e667993159c9fb177401b86e733f8cd81e0cfe48e508b8af897d39fd1e" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
