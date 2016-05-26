require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.5.tar.gz"
  sha256 "352c0c311710907d112e5d2745e7b152adc4d7b23aff3f069c463eceedddec17"
  revision 1

  bottle do
    sha256 "de6d5e476a1738fea563a7ea142f0f28c658c7d92dd53d3431df2f5efc283b16" => :el_capitan
    sha256 "c0ac7cfaedc4de5b082a6a3de75cf7a2475a000dcec77c84315ae46cf86f4185" => :yosemite
    sha256 "563619bc58950f7f4fb3ff065ccf9df01f5a15190bc885718a3202425d654e20" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
