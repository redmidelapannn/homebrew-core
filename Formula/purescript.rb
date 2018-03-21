require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.11.7.tar.gz"
  sha256 "56b715acc4b92a5e389f7ec5244c9306769a515e1da2696d9c2c89e318adc9f9"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "70768b5e163b248a5c3b5ec42d4c8cb44792ca814de1ee105bd0c779a640b4a0" => :high_sierra
    sha256 "85034d9e98c4120751dbd3fa7107487b7a65022c68846c02a1972cdfef77b6d6" => :sierra
    sha256 "66b28c2750125694f72892194efb01f0de2d197b7abb2727bb1c353ca5ef2042" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    inreplace (buildpath/"scripts").children, /^purs /, "#{bin}/purs "
    bin.install (buildpath/"scripts").children

    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      else
        system "cabal", "get", "purescript-#{version}"
        mv "purescript-#{version}/purescript.cabal", "."
      end

      install_cabal_package "-f", "release", :using => ["alex", "happy"]
    end
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
