require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.5/hlint-2.1.5.tar.gz"
  sha256 "41f21566627d02f69f5715d883ebffd54e64e8f2af1d2376830b6880565a7102"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    rebuild 1
    sha256 "0064be602a2e63caa86822853ab9e5369e22f6f96bbbb85ad7f8ee8536a5b61a" => :high_sierra
    sha256 "4443254ea2183d68321d5391bf2c35269c52e6dd4dcb0b2bd00c65abeae85c99" => :sierra
    sha256 "99107ef2af062e792bb16253abfa2a2b468e2168ee2a0a15b59ee0a734d9e2c6" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => "happy"
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
