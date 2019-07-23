require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.1/hlint-2.2.1.tar.gz"
  sha256 "f3b281c68e18815e57f9ec6a41aa75c07da0dc0a386c60e42b31902f606874c8"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "205642887bc711d97d219862e3b47f303217819c4339548bbd0d9f5869736f8f" => :mojave
    sha256 "ebfd415a6af5a1c2ecf9de6ecda878336b948520090926aef91a5a69736bff06" => :high_sierra
    sha256 "5a7922ca493c1df4a19435ce2d8cbdec94f1eb055bf9e6f40a6ab12520222ed7" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
