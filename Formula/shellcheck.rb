require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.7.tar.gz"
  sha256 "3fd7ebec821b96585ba9137b7b8c7bd9410876490f4ec89f2cca9975080a8206"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef0fd41f7a1a10d7e9e8f68b224fb8a45e4311ad329a9fcd59be2ca30f452091" => :high_sierra
    sha256 "502af78ec1bba372a6185c37e139b2cf7cfeff1c27a5d5b7b395d859783e3e8f" => :sierra
    sha256 "8e4daf5b0b814c1e08a94770f6f4fb218dab35e3a96754397c98d9bb4b492eeb" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
