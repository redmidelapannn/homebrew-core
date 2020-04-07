require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.11/hlint-2.2.11.tar.gz"
  sha256 "7c15ec4f3d328fbeb38faf9a49c158d25ec94d82630629d4db3086da73decaf7"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    rebuild 1
    sha256 "80b59edbe4474622fb4de23ff8be85143dd1dd33356723104cc8eafc851fff0f" => :catalina
    sha256 "30ef439543682e5e2ab71912a97c2ced7df26d7309642b9680d9ba07697063e0" => :mojave
    sha256 "c51145f6368ecbbca4f721d0f48cdda5bbbb123030df2308000dc4a483ec52c9" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "ncurses"

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
