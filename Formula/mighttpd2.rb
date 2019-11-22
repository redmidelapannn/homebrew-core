require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "12a6b398b170fbf0d62ad1184b1955a4420a572e9380179cb5bdfa769e7925ec" => :catalina
    sha256 "2eddf06283cd407663d9bf4dfad18d4d2e5aa3c0f13e198b556ee5123331e616" => :mojave
    sha256 "184f63f8a59d7f58629fd0aa16a7e719e38d745c24dfb7e18154d36abba16eec" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
