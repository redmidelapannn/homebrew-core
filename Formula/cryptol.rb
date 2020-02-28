require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.8.0/cryptol-2.8.0.tar.gz"
  sha256 "b061bf88de09de5034a3707960af01fbcc0425cdbff1085c50c00748df9910bb"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f7704829cb27aa88756696912e6d35001f2aea1e8bf43a35f4cfaa535d745e7b" => :catalina
    sha256 "8565b45a7900ce46a2ca996e0ba5930f4389b05d3b0a059337ac794f1b1596d3" => :mojave
    sha256 "843979033150ac4921334a4a11a651056b77037dad4948364b5d29ca2921db8f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build # 8.8 will be supported in the next release
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
