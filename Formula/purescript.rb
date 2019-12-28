require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.13.5/purescript-0.13.5.tar.gz"
  sha256 "44260d0cf86d35eb95e2fc348c986508f9b082f708ab53a3985170e518fd985e"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b77e05a82517a66ba26e1e1a56bae045ac3af4b11173070b701241af01f6dfc7" => :catalina
    sha256 "bb346014a54feee62a13f847c83ad561a14db2e57a2239bc5c3e8d4841e973e5" => :mojave
    sha256 "5b813503f20594c7ffeb48004666efe08eb38b281461f0cebe5a12c215d164ea" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  if build.head?
    depends_on "hpack" => :build
  end

  def install
    if build.head?
      system "hpack"
    end

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
