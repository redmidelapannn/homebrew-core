class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.13.6/purescript-0.13.6.tar.gz"
  sha256 "12f5efa2e157a8d57e6f5a4318d08ff57796802ec3e404f5436371b32f1f5af7"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e992228cf776393d8d0007280c01279736097e18d8333747b1810c45cd3ef7f" => :catalina
    sha256 "4a7481b4bdbbaff746c6e084ddd8e3352ee23334472e5c1ce6cee4d36bdd642d" => :mojave
    sha256 "8a90b3e74fae67f697b573050a7cee4f7781e7f12fbd6a5145881c32f68f5e87" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  depends_on "hpack" => :build if build.head?

  def install
    system "hpack" if build.head?

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
