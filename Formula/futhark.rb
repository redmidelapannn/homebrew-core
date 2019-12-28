require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.13.2.tar.gz"
  sha256 "51b1c4bf3cac469dabbf66955049480273411cf5eb50da235f0a4c96cffe2b8e"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ac62782212d010ceae519cb8471a696804fab69403562fe94b3834720cbcab42" => :catalina
    sha256 "a85de2913f962c6a63b60d120840b68ead8725d6a1c4d748db85c17c2a07bec6" => :mojave
    sha256 "957162d718c88994d589f114545d87d48116d60d9d91f39c52adfc6b3c998566" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "sphinx-doc" => :build

  def install
    # Futhark provides a cabal.project.freeze for pinning Cabal
    # dependencies, but this is only picked up by "v2" builds, and
    # as of this writing, Homebrew still does sandboxed "v1" builds.
    # Fortunately, the file formats seem to be compatible.
    mv "cabal.project.freeze", "cabal.config"

    system "hpack"

    install_cabal_package :using => ["alex", "happy"]

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
