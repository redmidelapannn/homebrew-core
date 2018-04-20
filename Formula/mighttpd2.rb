require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.2/mighttpd2-3.4.2.tar.gz"
  sha256 "7330e73d5b07d5dded9e18d04681f6c34e46df6b4635ff483c57c90c344bb128"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "04f667db8a24f6b8fb402f45a6738766ddfc5097c209d5ae12e05cd149cc68a2" => :high_sierra
    sha256 "1f42bba7aae97149b75eff579ceac986e10aca5b5e5edb2511bd7d6e20622e4d" => :sierra
    sha256 "f82f0973b26fd1292c9836bbe475fb6303b36d8081fb00d52c231232533b0aed" => :el_capitan
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
