require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.3/mighttpd2-3.4.3.tar.gz"
  sha256 "70dd2845c89917509674a903cdf3b9e54c47eb82a5ae199eb3bf3da56611ca29"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c80b882f0a1223b0a8c61425aebf474371d6437866fbf342582f7a2b6c841966" => :high_sierra
    sha256 "dc466326152893a93df0d792e18dfa463235740eedf2d74ae37ceef037ff273c" => :sierra
    sha256 "3bf23e59a7bd1c9a6795b9124cce27b527bc3f86055a7c6beff5ca65a4624a01" => :el_capitan
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
