require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.9/bench-1.0.9.tar.gz"
  sha256 "3c43d5b28abd7d07617ce5bf44756e8922db2dfbb39d7b123427b20eb8a9a830"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2c03b5c2c657f50a57c60acf0f42504159191cdf62d339f1790c5643a825923c" => :high_sierra
    sha256 "8bb9bdaa54b1d121c36cdab09362f40d1a2fa72b9a1220a42b8b02f2af65e894" => :sierra
    sha256 "cad2a2af310eef751c9828f562456172e8fc568f02c6e2a1e0c9c553a876752e" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
