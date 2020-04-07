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
    sha256 "100f160aeefe50858fca272869d369b52c03ff707bea39da1d896176dff82a97" => :catalina
    sha256 "322908a72279e28fb8058fe36a86f4e83544159c6d5843dfeff6caaf0388e7a4" => :mojave
    sha256 "88d5d6271227f8a0110913f1c652ed20ec8e5a9df2ff09194b7cb06858a0eed8" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

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
