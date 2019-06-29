require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.7.0/cryptol-2.7.0.tar.gz"
  sha256 "46c6ba5d63c0cdf074e57ea07b09dc84751a6608a9a66e552ebe2b7a343ed393"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "55ee09650351b4bcf8d368bc1563c279998336a27cbf2c3f946c531316594ffd" => :mojave
    sha256 "58de68fe94d3113bf732fdee6b261f420d44ee63e19b5060a1dee7f0050c0e13" => :high_sierra
    sha256 "7e967446094d0e382858229a2ae3761f14274a7442cd460c28680945c386c1a4" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"
  uses_from_macos "ncurses"

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
