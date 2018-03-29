require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.10.1.1/texmath-0.10.1.1.tar.gz"
  sha256 "52c9638e06ea66a6b75d1d3cce4eb0ebad66af5ce3e53c6c90a6b1564ba34e60"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2872fd1b8b231f0e0379c2c01e74b669189afe0c0afd0e8bc4c4a6c09f3838d0" => :high_sierra
    sha256 "411a517c636c337a04cb6ad0c8892ad2c5cc678e8e694928cb8741851b1b7216" => :sierra
    sha256 "e4ae9db894287205cd3d451c1368fdb6b36a35e81c18aefb4da57e51adf2b5d3" => :el_capitan
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
