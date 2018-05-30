require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9/shelltestrunner-1.9.tar.gz"
  sha256 "cbc4358d447e32babe4572cda0d530c648cc4c67805f9f88002999c717feb3a8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "942fbabd56965036cab782db40c3f74d1e192ed4a88b2256bc776a22d6958f86" => :high_sierra
    sha256 "9a1a4ae783b110356e630a6f68bf1342e7041e89244c77c36f3108162c0061e8" => :sierra
    sha256 "4128b88752f185b49a4721fe0fc3cd0be3c17df35d76ca08cce58fb1f446a933" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    (testpath/"test").write "$$$ {exe} {in}\n>>> /{out}/\n>>>= 0"
    args = "-D{exe}=echo -D{in}=message -D{out}=message -D{doNotExist}=null"
    assert_match "Passed", shell_output("#{bin}/shelltest #{args} test")
  end
end
