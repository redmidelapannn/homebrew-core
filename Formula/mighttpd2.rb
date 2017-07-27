require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.1/mighttpd2-3.4.1.tar.gz"
  sha256 "0f24c72662be4a0e3d75956fff53899216e29ac7eb29dae771c7e4eb77bdd8d5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "003fe215b5e01d7addf1a55553b1756ed053b008c1c636a6ef539860fe048bb7" => :sierra
    sha256 "f071b3eb024104cbc456a67913540c081145da0d524d978f2bcf6fcbdc040a3a" => :el_capitan
    sha256 "02a487416f68554740f466e382b1766345b71e09cc52b190db8bb7fb441ba45f" => :yosemite
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
