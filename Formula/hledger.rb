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
    sha256 "eb23b18dba48ca70ad0c1efb5fa9a6b83aaeea443ed0cbffaebae71644d52aed" => :high_sierra
    sha256 "acf99f9d222f373c430de8b743be1684d75b29cb2088cbde85ae519011bdf9f6" => :sierra
    sha256 "05e29235e4d9f95c654a34fb909b65ad4c08a7a9db5936d1e815cc84f5c48aad" => :el_capitan
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
