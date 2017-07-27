require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.9.4.1/texmath-0.9.4.1.tar.gz"
  sha256 "302202b2c896403963aefe63044ca65ca277482d0e661607010ca3bf8d9a9d04"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1141e05097080fb00e973ac5bb3d017244ed79fc093154a8330cea7ff30d8890" => :sierra
    sha256 "37e2ed9d8493a72f21247259141aa2d03d414bad815769927c4967f5dc40f74b" => :el_capitan
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
