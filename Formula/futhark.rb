require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.5.2.tar.gz"
  sha256 "c77dd18b910b1d7c934d2941db6b22591c53a2bc0c90addfa6f14df6747e080e"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d811f1c4818540ebb720291274d6b2c80ad6ea3ca59a2e95c243ca6fd789d919" => :high_sierra
    sha256 "d6d10e4be0761092e302d6e8299009073cf287ce792c1aad39bf137527ea7e63" => :sierra
    sha256 "61c6d2d147cb16035ef35f9a55eb8c585bde7298e35c12bd39dcc9150687f46c" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"

      install_cabal_package :using => ["alex", "happy"]
    end

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
