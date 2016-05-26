require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.2.10/mighttpd2-3.2.10.tar.gz"
  sha256 "b5d8b8a310598d952f3b4329808ef8211a6a0b224d66fcc18cef4f0a737d25f1"
  revision 1

  bottle do
    sha256 "b403e8798ebb88d064e84604fa61e5454f56d67d4e277fd1ffa9602f77fbde5d" => :el_capitan
    sha256 "21190271e8b58beb58b80bfda431b5b59dcff2c5acba086448e54cd616861c3c" => :yosemite
    sha256 "adca50136c5912bb17345e9d8ea6d1b44ce0f6f0dee08fdbafc09e6fa78d49db" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
