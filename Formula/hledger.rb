require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.3/hledger-1.3.tar.gz"
  sha256 "ade9800e4a3fab47b48c6cdbe432d261f3398f71514eb2c554a14f8f8c542f2d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "546e4dad644f53380e463a2d96cb4376f6b8ddfce8b52530595fae3e7acc0f08" => :sierra
    sha256 "8f71fe5552ba8475314a9f5d86c5260f07c9285b9d81a3ee24717d3288575b9b" => :el_capitan
    sha256 "661b656d59e84cd43c0e50f4725bbf5c2dbeded23fed3c7b136e5b59a5737bed" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
