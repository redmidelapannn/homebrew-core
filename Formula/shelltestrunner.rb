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
    sha256 "67593ca39a7becd9e8416a753644cbd968474f98aea1e93d67774c4bc635973c" => :catalina
    sha256 "82da00462e649265c8eeabbc1510465ddd1df6c82c71a4a785d0019c535f8f05" => :mojave
    sha256 "e3cb3fd8b7af271b170b24d74034ead131b10d94243578fd84518ddd91604407" => :high_sierra
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
