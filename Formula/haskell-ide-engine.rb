class HaskellIdeEngine < Formula
  desc "The engine for haskell ide-integration. Not an IDE"
  homepage "https://github.com/haskell/haskell-ide-engine"

  url "https://github.com/haskell/haskell-ide-engine.git",
    :revision => "0.2.1.0"
  bottle do
    sha256 "d99f7ce39dc78e1e5a9a863641d011894ee2b6f69ff0ecbc53248c87d2629e67" => :mojave
    sha256 "8bd8e61aae40048386ea49176c58bb69d75e41883d198ef6884ce37dc9fddddd" => :high_sierra
    sha256 "c1d1e714c4f1fc1577869354857d895244f77c5489b12a43a821b3e25c5c4af1" => :sierra
  end

  
  head "https://github.com/haskell/haskell-ide-engine.git"

  version "0.2.1.0"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "git", "submodule", "update", "--init"
    system "cabal", "new-update"
    system "cabal", "new-configure"
    system "cabal", "new-build"
    bin.install Dir["dist-newstyle/build/x86_64-osx/ghc-*/haskell-ide-engine-*/x/hie/build/hie/hie"]
  end

  def caveats; <<~EOS
    This version of hie is only compatible with projects built with the version of GHC used while building this.
    Visit https://github.com/haskell/haskell-ide-engine for instructions on installing multiple versions.
  EOS
  end

  test do
    system "#{bin}/hie", "--version"
  end
end
