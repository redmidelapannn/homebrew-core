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
    sha256 "eb114fd8499ae21d379cba581a96f2e76e81da46d2fba9c52021c27b03b8a190" => :high_sierra
    sha256 "46aaf4e7730a5f5bec9232feb52ca521c916d18facacfb0b140071d4a82acd67" => :sierra
    sha256 "ec198ee16c33f4bfe1064eaf069c0e041c81e279d7062b92e4d2cdc1dbdff855" => :el_capitan
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
