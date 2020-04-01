require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.3.tar.gz"
  sha256 "0f13890f9e2eb0b487be53a2c26c71d1bad19a9ba7a6fc5e72f3c03cfbe6c220"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8b9555344c5e5ed6e9dae1e6fe7212564ffd3ab2b38a14f8fde93f76461e4e7" => :catalina
    sha256 "9af26ce54ebd8ff42505dd5f334398d5e171e9a8d7a6741e36f5219a62dca396" => :mojave
    sha256 "e34086247e309f7a0e93695de3a76d19aaf40ce0c0d95137020733de789fc4a2" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
