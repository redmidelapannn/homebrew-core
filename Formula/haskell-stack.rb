require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.9.3/stack-1.9.3-sdist-1.tar.gz"
  version "1.9.3"
  sha256 "14e06a71bf6fafbb2d468f83c70fd4e9490395207d6530ab7b9fc056f8972a46"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bfd52e33adb1a5e4a5851dec80a587957a5db8da01be6fef63f89c6156cfc9c6" => :mojave
    sha256 "4f3e4bd856f790584d6ea552c9dedf7ecad2b63556856e912fa7f4d8202e8050" => :high_sierra
    sha256 "3e5c786fc712c516df9371ac5e145ba8963543e53a7a0e36e6d59cb2582793a8" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Build using a stack config that matches the default Homebrew version of GHC
  resource "stack_lts_12_yaml" do
    url "https://raw.githubusercontent.com/commercialhaskell/stack/v1.9.3/stack-lts-12.yaml"
    version "1.9.3"
    sha256 "0b4fb72f7c08c96ca853e865036e743cbdc84265dd5d5c4cf5154d305cd680de"
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
