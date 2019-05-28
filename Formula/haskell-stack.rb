require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.9.3/stack-1.9.3.1-sdist-1.tar.gz"
  version "1.9.3.1"
  sha256 "83408c27e7d0b0b486b7b6dc92b3631ba57bace6d1421d08b621ac50205df5f8"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75cf9d71f3487f3c6e482dcdcf2c3076568084f462ac65813f2bb92fee7c8303" => :mojave
    sha256 "8259e1d6e84d50dd0a2b7565f8cdcff3c2454b6677623e026bdfe3c26def1be7" => :high_sierra
    sha256 "00442186fe71bd4105e7a63ba797cb7c22e8da138165bbbad6e46ed681bc6c5c" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Build using a stack config that matches the default Homebrew version of GHC
  resource "stack_lts_12_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.9.3.1/stack-lts-12.yaml"
    version "1.9.3.1"
    sha256 "12f11d6cc4d9c802c8e0076d3836ebb01d964f9547537108176d65e5695f6f4a"
  end

  def install
    buildpath.install resource("stack_lts_12_yaml")

    cabal_sandbox do
      cabal_install "happy"

      cabal_install

      # Let `stack` handle its own parallelization
      # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
      jobs = ENV.make_jobs
      ENV.deparallelize

      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "setup"
      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
