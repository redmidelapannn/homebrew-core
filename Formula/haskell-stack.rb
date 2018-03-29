require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.6.5/stack-1.6.5-sdist-1.tar.gz"
  version "1.6.5"
  sha256 "71d02e2a3b507dcde7596f51d9a342865020aa74ebe79847d7bf815e1c7f2abb"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a28a1b840bf2bdb70ede0de7bc0e7cf0819c48d6daf2c0e0b3b1fc81cc42de90" => :high_sierra
    sha256 "0deea29f2a8d7e43ef517522de4dc795376e282730697ae0ac94dee11ee72d40" => :sierra
    sha256 "ce0af732e6443c8eb5fee8ad96b01427f029f7237555af6005ffbaf292c6e570" => :el_capitan
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  # Remove when stack.yaml uses GHC 8.2.x
  resource "stack_nightly_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.6.5/stack-nightly.yaml"
    version "1.6.5"
    sha256 "07ef0e20d4ba52a02d94f9809ffbd6980fbc57c66316620ba6a4cacfa4c9a7dd"
  end

  def install
    buildpath.install resource("stack_nightly_yaml")

    cabal_sandbox do
      cabal_install "happy"

      if build.with? "bootstrap"
        cabal_install

        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize

        system "stack", "-j#{jobs}", "--stack-yaml=stack-nightly.yaml", "setup"
        system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
      else
        install_cabal_package
      end
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
