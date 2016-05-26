require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://github.com/jgm/texmath/archive/0.8.4.1.tar.gz"
  sha256 "f3e6e8ba0136462299c8873e9aefc05aa61a85b782ba8e487d4fc4a1fe10005f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "aefaed46926f5a644c44539a0eabb7dd97dca7d656d614e741c8939fe6c8e04c" => :el_capitan
    sha256 "a559d9c9f1e56f4839ed15395200caf17aec11d7161f02b134dc49bfd6831c43" => :yosemite
    sha256 "d3502a86262877f11e49d644423ad791c233d08a35ec8e8c1126aa19abf743bd" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "-f executable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output("texmath", "a^2 + b^2 = c^2")
  end
end
