require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.3/hlint-2.1.3.tar.gz"
  sha256 "6abc547c380937af2bb51570425c7edf6402ee051d6e1a6f4417d44d125a2722"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    rebuild 1
    sha256 "4c0767915a50e3ba9ade8dfa5e3d4ffe3bc34b4928988ee1737653866ee770b4" => :high_sierra
    sha256 "c95a6ea46325cff2e6d89073acd37aad8325a813f59591d0f59b2569bb37694f" => :sierra
    sha256 "2eaf87ecb628d942487bdda45886993e6e1ab4856954db914fe2722d59966291" => :el_capitan
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
