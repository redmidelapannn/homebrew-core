require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.13.6/purescript-0.13.6.tar.gz"
  sha256 "12f5efa2e157a8d57e6f5a4318d08ff57796802ec3e404f5436371b32f1f5af7"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2dc7e92986e2084896c6ffc2e85564be2a15f9de8251609e3f30d3b610a394e8" => :catalina
    sha256 "c87fe05a19c65ef7811e5dfc8cd3123a6af8bb6d7db76b8b72ac9da316ab0e31" => :mojave
    sha256 "6d26f55e1021591169efa935db35ad3a2bbf9805a85ddff00931234cd016ecaa" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  depends_on "hpack" => :build if build.head?

  def install
    system "hpack" if build.head?

    install_cabal_package "-f", "release", :using => ["alex", "happy-1.19.9"]
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
