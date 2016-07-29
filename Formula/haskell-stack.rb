require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.1.2/stack-1.1.2-sdist-2.tar.gz"
  version "1.1.2"
  sha256 "8197e055451437218e964ff4a53936a497a2c1ed4818c17cf290c9a59fff9424"
  revision 3
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "48e171fcdd70d8177b2b7003607ba882667d06965d23e6f1b8adc392045babf3" => :el_capitan
    sha256 "1755fcc1254d4fe9dd64fbb98c43a8f9463787d0aa7617744d0c50942d203836" => :yosemite
    sha256 "8fa551dc2b6965c5056920cd6abad822ced8d44aa0396f08e4e4ca6ef0d8e599" => :mavericks
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    if build.with? "bootstrap"
      cabal_sandbox do
        cabal_install
        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize do
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      end
    else
      install_cabal_package
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
