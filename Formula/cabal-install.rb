class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-2.4.1.0/cabal-install-2.4.1.0.tar.gz"
  sha256 "69bcb2b54a064982412e1587c3c5c1b4fada3344b41b568aab25730034cb21ad"
  head "https://github.com/haskell/cabal.git", :branch => "2.4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef4a22b71d125e63cdcfeea11e36007cf74fbeca20fc5c9fd62b92d6b1c90c2e" => :mojave
    sha256 "be238b844ea2eda96489d86038e616aa3cd1ff746aff25e57402330245eec043" => :high_sierra
    sha256 "af04fa0dcefbbfbf8a5b98ed9e228a26fced974df434019b7b79ebb69d3cc4d4" => :sierra
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  def install
    cd "cabal-install" if build.head?

    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
