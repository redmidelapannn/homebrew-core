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
    sha256 "84c38a8cbf0906faba475c0a768331e7ceadd424e58e0b06208f414d86abc354" => :catalina
    sha256 "44352747cfb5541441979b6c88843e1f9dd66c058786d7daa8fa75a363cb4134" => :mojave
    sha256 "6b4ba5ddc735d8472b8e8413f66e5445c373a3133810742ecaae668eefc82309" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    (testpath/"test").write "$$$ {exe} {in}\n>>> /{out}/\n>>>= 0"
    args = "-D{exe}=echo -D{in}=message -D{out}=message -D{doNotExist}=null"
    assert_match "Passed", shell_output("#{bin}/shelltest #{args} test")
  end
end
