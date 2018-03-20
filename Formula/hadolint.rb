require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.5.1.tar.gz"
  sha256 "e70e295246193a5b0f2a7d1fc57072ae0e6d5f1178e9fd4cd8abbbb292287f16"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "595ad11f51128637e77d67b6f0f0416d4234d62e1750b7a8d813c2dc9a8db15b" => :high_sierra
    sha256 "4a99c4da2fed6cbb373482652b6c49bd2fa99d2849de6b90247108fed8b807fc" => :sierra
    sha256 "afe0d0e2a3e5f0f1370ff0d213ff9d4b281d847e4f2495245f6a40bdfbd3ba5a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
    end

    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
