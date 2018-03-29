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
    sha256 "e311868c12d8815f18110df431cfe92af76685658e2d4cbc3265f6cc3bef590c" => :high_sierra
    sha256 "f94dada56696a7772b8d6e3159baf7094edf39b75996aad629b982a6f15bb3c6" => :sierra
    sha256 "5d180e319f07993575e42c9db17bf42158bd3469ee3c46c78bf8005922887485" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

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
