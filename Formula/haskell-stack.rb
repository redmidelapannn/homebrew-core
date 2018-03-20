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
    sha256 "61048d6b8e93a162aadba907cc87b4e1bc4acdceb718d17d4b55a5188afc5473" => :high_sierra
    sha256 "8427742bf54a7f142f664672303afa0e0e7fa48c4dd89f6b36ac54054a30de23" => :sierra
    sha256 "37c016c833dc5d02b1ef6094b55448d90e56e87ca193a7ace1d1bc3aabf26fa6" => :el_capitan
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
