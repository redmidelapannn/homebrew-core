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
    sha256 "b0dcd03d10f16780a8ee6fa0193dedf31f10103afb49028c60403b066ee7e614" => :catalina
    sha256 "5833fddcf6394a49bd56ddcc5bac864fb26b0529b8d9cc145ee335cb6206ee83" => :mojave
    sha256 "ec9695369669338d23647a74d68818a03cb881a0cd8ddb383ec8ee003323398d" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
