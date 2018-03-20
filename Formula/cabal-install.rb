class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.0.0.1/cabal-install-2.0.0.1.tar.gz"
  sha256 "f991e36f3adaa1c7e2f0c422a2f2a4ab21b7041c82a8896f72afc9843a0d5d99"
  head "https://github.com/haskell/cabal.git", :branch => "2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c54630382ea06f6515b44fa556914281f4313816e4c66216c4caa415a9da376a" => :high_sierra
    sha256 "9425f8aa4f2dbc8afb52aa699281a5e63f584ace64bc063472aa5366db17c244" => :sierra
    sha256 "1c40901f1bbe5cb0e2511e022cf1d4237c647153746e1f262d49c5d9959f6e6a" => :el_capitan
  end

  depends_on "ghc@8.2"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if build.head?

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    ENV.prepend_path "PATH", Formula["ghc@8.2"].opt_bin
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
