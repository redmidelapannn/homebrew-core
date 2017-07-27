require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.2.tar.gz"
  sha256 "600731b0ebf8b86d561ea7ff37424d3249ccd36b91c440551200829c2f80f646"

  bottle do
    cellar :any_skip_relocation
    sha256 "d669f34a45f0471a6026ad4d355d41d84c4f21779bce68bf8059c95945442f14" => :sierra
    sha256 "1a0c56894b718a5f9e8f0a970edff550afddc986f9a1482e3bf009903a8a633b" => :el_capitan
    sha256 "ce50bf0e48cccbddbb164b789833dae23df90ce8cfb0cbf9120b463e5d7b2ffe" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # Fix "src/Hadolint/Bash.hs:9:20: error: The constructor 'PositionedComment'
    # should have 3 arguments, but has been given 2"
    # Reported 9 Dec 2016 https://github.com/lukasmartinelli/hadolint/issues/72
    install_cabal_package "--constraint=ShellCheck<0.4.5"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<-EOS.undent
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
