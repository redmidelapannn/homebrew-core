require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.12/bench-1.0.12.tar.gz"
  sha256 "a6376f4741588201ab6e5195efb1e9921bc0a899f77a5d9ac84a5db32f3ec9eb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "206cc9600d6724c4c7b4f09c6ea9704cea2bc9b54b272a55996191ef88cb3335" => :catalina
    sha256 "abcdf8229564c519f3d46153c9f58c61f51923e0ce0df9ba1f5805896012530c" => :mojave
    sha256 "1f6d5e85dbf9f1149a22471799a99531b11ec284ee8d9c8c61a0da010385c1bc" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Compatibility with GHC 8.8. Remove with the next release.
  patch do
    url "https://github.com/Gabriel439/bench/commit/846dea7caeb0aee81870898b80345b9d71484f86.patch?full_index=1"
    sha256 "fac63cd1ddb0af3bda78900df3ac5a4e6b6d2bb8a3d4d94c2f55d3f21dc681d1"
  end

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
