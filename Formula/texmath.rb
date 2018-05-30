require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.11.0.1/texmath-0.11.0.1.tar.gz"
  sha256 "4ec7f6ec41b38d184ca5069440f09ff2b50ff8318809c880f8da79eb6002ac85"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b6fdeceb3d890b793e149b1bcd5598f20555e8c117311e34b4e2b3bf4175bda" => :high_sierra
    sha256 "78113ba8c7d08fe60f54ff4bcf330e0a38cd1fb342af1e0c647dcfe3945e5389" => :sierra
    sha256 "1a886b2e64a0ce0934335b9bc46f912d8211369fdc7e70294404b84ad9c6c960" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "--enable-tests", :flags => ["executable"] do
      system "cabal", "test"
    end
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
